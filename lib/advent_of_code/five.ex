defmodule AdventOfCode.Five do
  def star_one(filename \\ "five.txt"), do: process_file(filename, &star_one_reducer/2)
  def star_two(filename \\ "five.txt"), do: process_file(filename, &star_two_reducer/2)

  def process_file(filename, reducer) do
    [{rules, updates}] =
      filename
      |> AdventOfCode.read_input()
      |> Stream.scan({[], []}, &rules_parser/2)
      |> Stream.take(-1)
      |> Enum.to_list()

    Enum.reduce(updates, 0, fn update, acc ->
      acc + apply(reducer, [update, rules])
    end)
  end

  def rules_parser(line, {rules, updates}) do
    cond do
      line =~ ~r/(\d+)\|(\d+)/ ->
        {add_line_to_rules(line, rules), updates}

      line =~ ~r/^$/ ->
        # Empty string
        {rules, updates}

      true ->
        {rules, add_line_to_updates(line, updates)}
    end
  end

  defp add_line_to_rules(line, rules) do
    new_rule =
      line
      |> String.split("|", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    rules ++ [new_rule]
  end

  defp add_line_to_updates(line, updates) do
    new_update =
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    updates ++ [new_update]
  end

  def star_one_reducer(update, rules) do
    if update_follows_rules?(update, rules) do
      Enum.at(update, floor(length(update) / 2))
    else
      0
    end
  end

  def star_two_reducer(update, rules) do
    if update_follows_rules?(update, rules) do
      0
    else
      fixed_update = fix_update_by_rules(update, rules)
      Enum.at(fixed_update, floor(length(fixed_update) / 2))
    end
  end

  defp update_follows_rules?(update, rules) do
    rules
    |> find_relevant_rules(update)
    |> Enum.map(fn {left, right} ->
      left_index = Enum.find_index(update, fn u -> u == left end)
      right_index = Enum.find_index(update, fn u -> u == right end)

      left_index < right_index
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.all?()
  end

  defp find_relevant_rules(rules, update) do
    rules
    |> Enum.filter(fn {left, right} ->
      left in update and right in update
    end)
  end

  defp fix_update_by_rules(update, rules) do
    relevant_rules = find_relevant_rules(rules, update)

    Enum.sort(update, fn a, b ->
      case {find_rule_position(a, b, relevant_rules), find_rule_position(b, a, relevant_rules)} do
        {:left, _} ->
          true

        {_, :left} ->
          false

        _ ->
          a < b
      end
    end)
  end

  def find_rule_position(a, b, rules) do
    if Enum.any?(rules, fn {left, right} -> left == a and right == b end), do: :left, else: :none
  end
end
