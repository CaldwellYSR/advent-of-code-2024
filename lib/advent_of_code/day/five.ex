defmodule AdventOfCode.Day.Five do
  alias AdventOfCode.Five.{RuleParser, UpdateProcessor}
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "five.txt"), do: process_file(filename, &UpdateProcessor.star_one/2)
  @impl Day
  def star_two(filename \\ "five.txt"), do: process_file(filename, &UpdateProcessor.star_two/2)

  @impl Day
  def process_file(filename, reducer) do
    {rules, updates} =
      filename
      |> AdventOfCode.read_input()
      |> RuleParser.parse()

    Enum.reduce(updates, 0, &(reducer.(&1, rules) + &2))
  end
end

defmodule AdventOfCode.Five.RuleParser do
  def parse(input) do
    Enum.reduce(input, {[], []}, &parse_line/2)
  end

  defp parse_line(line, {rules, updates}) do
    cond do
      String.match?(line, ~r/(\d+)\|(\d+)/) ->
        {[parse_rule(line) | rules], updates}

      line == "" ->
        {rules, updates}

      true ->
        {rules, [parse_update(line) | updates]}
    end
  end

  defp parse_rule(line) do
    line
    |> String.split("|", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_update(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule AdventOfCode.Five.UpdateProcessor do
  def star_one(update, rules) do
    if update_follows_rules?(update, rules) do
      middle_value(update)
    else
      0
    end
  end

  def star_two(update, rules) do
    if update_follows_rules?(update, rules) do
      0
    else
      update
      |> fix_update_by_rules(rules)
      |> middle_value()
    end
  end

  defp update_follows_rules?(update, rules) do
    rules
    |> find_relevant_rules(update)
    |> Enum.all?(fn {left, right} ->
      left_index = Enum.find_index(update, &(&1 == left))
      right_index = Enum.find_index(update, &(&1 == right))
      left_index < right_index
    end)
  end

  defp find_relevant_rules(rules, update) do
    Enum.filter(rules, fn {left, right} ->
      left in update and right in update
    end)
  end

  defp fix_update_by_rules(update, rules) do
    relevant_rules = find_relevant_rules(rules, update)
    Enum.sort(update, &compare_by_rules(&1, &2, relevant_rules))
  end

  defp compare_by_rules(a, b, rules) do
    cond do
      rule_exists?(a, b, rules) -> true
      rule_exists?(b, a, rules) -> false
      true -> a < b
    end
  end

  defp rule_exists?(a, b, rules) do
    Enum.any?(rules, fn {left, right} -> left == a and right == b end)
  end

  defp middle_value(list) do
    Enum.at(list, div(length(list), 2))
  end
end
