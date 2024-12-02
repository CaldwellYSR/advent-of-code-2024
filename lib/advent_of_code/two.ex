defmodule AdventOfCode.Two do
  def star_one(filename \\ "two.txt"), do: process_data(filename, &is_line_safe/1)
  def star_two(filename \\ "two.txt"), do: process_data(filename, &is_line_safe_with_removals/1)

  def process_data(filename, safety_check) do
    filename
    |> AdventOfCode.read_input()
    |> Stream.map(&parse_line/1)
    |> Stream.map(safety_check)
    |> Enum.sum()
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def is_line_safe([]), do: 0

  def is_line_safe(line) do
    changes = calculate_changes(line)
    if valid_changes?(changes), do: 1, else: 0
  end

  def calculate_changes(line) do
    line
    |> Enum.zip(tl(line) ++ [List.first(line)])
    |> List.delete_at(length(line) - 1)
    |> Enum.map(fn {a, b} -> b - a end)
  end

  defp valid_changes?(changes) do
    Enum.all?(changes, &(&1 in -3..3)) and
      (Enum.all?(changes, &(&1 > 0)) or Enum.all?(changes, &(&1 < 0)))
  end

  def is_line_safe_with_removals([]), do: 0

  def is_line_safe_with_removals(line) do
    if is_line_safe(line) == 1 or any_safe_removal?(line), do: 1, else: 0
  end

  defp any_safe_removal?(line) do
    0..(length(line) - 1)
    |> Enum.any?(fn i ->
      line
      |> List.delete_at(i)
      |> is_line_safe() == 1
    end)
  end
end
