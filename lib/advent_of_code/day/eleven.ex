defmodule AdventOfCode.Day.Eleven do
  def star_one(filename \\ "eleven.txt"), do: process_file(filename, 25)
  def star_two(filename \\ "eleven.txt"), do: process_file(filename, 75)

  def process_file(filename, times) do
    initial_map =
      filename
      |> AdventOfCode.read_full_file()
      |> String.replace("\n", "")
      |> String.split(" ", trim: true)
      |> Enum.reduce(%{}, fn num, acc -> Map.put(acc, num, 1) end)

    Enum.reduce(1..times, initial_map, fn _, acc ->
      Enum.reduce(acc, %{}, fn {number, count}, new_acc ->
        process_number(number, count, new_acc)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp process_number("0", count, acc), do: Map.update(acc, "1", count, &(&1 + count))

  defp process_number(number, count, acc) do
    case String.length(number) do
      len when rem(len, 2) == 0 ->
        {left, right} = String.split_at(number, div(len, 2))

        right =
          case String.trim_leading(right, "0") do
            "" -> "0"
            s -> s
          end

        acc
        |> Map.update(left, count, &(&1 + count))
        |> Map.update(right, count, &(&1 + count))

      _ ->
        new_val = Integer.to_string(String.to_integer(number) * 2024)
        Map.update(acc, new_val, count, &(&1 + count))
    end
  end
end
