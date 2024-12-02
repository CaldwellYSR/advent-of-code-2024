defmodule AdventOfCode.Two do
  def star_one(), do: star_one("two.txt")

  def star_one(filename) do
    AdventOfCode.read_input(filename)
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.scan(0, fn line, count ->
      count + is_line_safe(line)
    end)
    |> Enum.reverse()
    |> List.first()
  end

  def star_two(), do: star_two("two.txt")

  def star_two(filename) do
    AdventOfCode.read_input(filename)
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.scan(0, fn line, count ->
      count + is_line_safe_with_removals(line)
    end)
    |> Enum.reverse()
    |> List.first()
  end

  def is_line_safe([]), do: 0

  def is_line_safe(line) do
    [first | rest] = line

    line_2 = Enum.reverse([first | Enum.reverse(rest)])

    [_ | test_line] =
      line
      |> Stream.zip(line_2)
      |> Enum.to_list()
      |> Enum.reverse()

    changes =
      test_line
      |> Enum.reverse()
      |> Enum.map(fn {a, b} -> b - a end)

    if Enum.max(changes) <= 3 and
         Enum.min(changes) >= -3 and
         (Enum.all?(changes, &(&1 > 0)) or Enum.all?(changes, &(&1 < 0))) do
      1
    else
      0
    end
  end

  def is_line_safe_with_removals([]), do: 0

  def is_line_safe_with_removals(line) do
    case is_line_safe(line) do
      1 ->
        1

      0 ->
        if Enum.map(0..(length(line) - 1), fn item ->
             {_, rest} = List.pop_at(line, item)
             rest
           end)
           |> Enum.any?(fn line -> is_line_safe(line) == 1 end) do
          1
        else
          0
        end
    end
  end
end
