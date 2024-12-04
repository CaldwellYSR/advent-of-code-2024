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
    bad_pair_index =
      line
      |> calculate_changes()
      |> get_bad_pair_index()

    if is_nil(bad_pair_index), do: 1, else: 0
  end

  def calculate_changes(line) do
    line
    |> Enum.zip(tl(line))
    |> Enum.map(fn {a, b} -> b - a end)
  end

  def is_line_safe_with_removals([]), do: 0

  # def is_line_safe_with_removals(line) do
  #  if is_line_safe(line) == 1 or any_safe_removal?(line), do: 1, else: 0
  # end

  def is_line_safe_with_removals(line) do
    line
    |> calculate_changes()
    |> get_bad_pair_index()
    |> any_safe_removal(line)
  end

  def any_safe_removal(nil, _), do: 1

  def any_safe_removal(bad_pair_index, line) do
    (bad_pair_index - 1)..(bad_pair_index + 1)
    |> Enum.any?(fn i ->
      line
      |> List.delete_at(i)
      |> is_line_safe() == 1
    end)

    if is_line_safe(line) == 1 or any_safe_removal?(line), do: 1, else: 0
  end

  def get_bad_pair_index(changes) do
    slope =
      changes
      |> List.first()
      |> get_slope()

    changes
    |> Enum.find_index(fn change ->
      abs_value = abs(change)

      abs_value < 1 or abs_value > 3 or get_slope(change) != slope
    end)
  end

  defp get_slope(change) when change < 0, do: -1
  defp get_slope(change) when change > 0, do: 1
  defp get_slope(_), do: nil

  defp any_safe_removal?(line) do
    0..(length(line) - 1)
    |> Enum.any?(fn i ->
      line
      |> List.delete_at(i)
      |> is_line_safe() == 1
    end)
  end
end
