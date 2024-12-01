defmodule AdventOfCode.One do
  def main() do
    {list_a, list_b} = get_data()

    Enum.zip(list_a, list_b)
    |> Enum.reduce(0, fn {a, b}, acc ->
      acc + abs(a - b)
    end)
  end

  def secondary() do
    {list_a, list_b} = get_data()
    frequencies = Enum.frequencies(list_b)

    Enum.reduce(list_a, 0, fn value, acc ->
      acc + find_similarity_score(value, frequencies)
    end)
  end

  defp find_similarity_score(value, frequencies) do
    occurrences =
      case Map.fetch(frequencies, value) do
        {:ok, val} -> val
        :error -> 0
      end

    value * occurrences
  end

  defp get_data() do
    data =
      AdventOfCode.read_input("one.txt")
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
