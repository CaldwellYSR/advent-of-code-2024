defmodule AdventOfCode.Day.One do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "one.txt"), do: process_file(filename, &star_one_parser/1)
  @impl Day
  def star_two(filename \\ "one.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, parser) do
    data = get_data(filename)

    apply(parser, [data])
  end

  def star_one_parser({list_a, list_b}) do
    Enum.zip(list_a, list_b)
    |> Enum.reduce(0, fn {a, b}, acc ->
      acc + abs(a - b)
    end)
  end

  def star_two_parser({list_a, list_b}) do
    frequencies = Enum.frequencies(list_b)

    Enum.reduce(list_a, 0, fn value, acc ->
      acc + find_similarity_score(value, frequencies)
    end)
  end

  defp find_similarity_score(value, frequencies) do
    occurrences =
      frequencies
      |> Map.fetch(value)
      |> parse_value()

    value * occurrences
  end

  defp parse_value({:ok, value}), do: value
  defp parse_value(:error), do: 0

  defp get_data(filename) do
    data =
      filename
      |> AdventOfCode.read_input()
      |> Stream.map(fn line ->
        [a, b] = String.split(line, " ", trim: true)
        {a, _rem} = Integer.parse(a)
        {b, _rem} = Integer.parse(b)
        {a, b}
      end)

    list_a =
      data
      |> Stream.map(fn {a, _} -> a end)
      |> Enum.sort()

    list_b =
      data
      |> Stream.map(fn {_, b} -> b end)
      |> Enum.sort()

    {list_a, list_b}
  end
end
