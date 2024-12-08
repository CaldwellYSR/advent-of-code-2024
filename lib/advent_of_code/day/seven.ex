defmodule AdventOfCode.Day.Seven do
  alias AdventOfCode.Day

  @operators [:times, :plus]
  @star_two_operators [:times, :plus, :concat]

  @behaviour Day

  @impl Day
  def star_one(filename \\ "seven.txt"), do: process_file(filename, &star_one_parser/2)

  @impl Day
  def star_two(filename \\ "seven.txt"), do: process_file(filename, &star_two_parser/2)

  @impl Day
  def process_file(filename, parser) do
    filename
    |> AdventOfCode.read_input()
    |> Enum.reduce(0, parser)
  end

  def star_one_parser(line, output) do
    [answer, equation] =
      String.split(line, ": ", trim: true)

    answer = String.to_integer(answer)

    equation =
      equation
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    combinations = intersperse_combinations(equation, @operators)

    if Enum.any?(combinations, fn combination ->
         test_combination(combination) == answer
       end) do
      output + answer
    else
      output
    end
  end

  defp test_combination([first | rest]) do
    Enum.chunk_every(rest, 2)
    |> Enum.reduce(first, fn
      [:times, number], value -> value * number
      [:plus, number], value -> value + number
      [:concat, number], value -> String.to_integer("#{value}" <> "#{number}")
    end)
  end

  defp intersperse_combinations(list, separators) do
    list
    |> Enum.zip(1..length(list))
    |> Enum.reduce([[]], fn {item, index}, acc ->
      if index == length(list) do
        Enum.map(acc, &(&1 ++ [item]))
      else
        Enum.flat_map(acc, fn sublist ->
          Enum.map(separators, fn sep ->
            sublist ++ [item, sep]
          end)
        end)
      end
    end)
  end

  def star_two_parser(line, output) do
    [answer, equation] =
      String.split(line, ": ", trim: true)

    answer = String.to_integer(answer)

    equation =
      equation
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    combinations = intersperse_combinations(equation, @star_two_operators)

    if Enum.any?(combinations, fn combination ->
         test_combination(combination) == answer
       end) do
      output + answer
    else
      output
    end
  end
end
