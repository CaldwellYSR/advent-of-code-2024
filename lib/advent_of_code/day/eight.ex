defmodule AdventOfCode.Day.Eight do
  alias AdventOfCode.Day
  alias AdventOfCode.Grid

  @behaviour Day

  @impl Day
  def star_one(filename \\ "eight.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "eight.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, _parser) do
    grid = AdventOfCode.read_file_to_grid(filename)

    grid
    |> Map.values()
    |> Stream.uniq()
    |> Stream.reject(&(&1 == "."))
    |> Stream.map(fn char ->
      grid
      |> Map.filter(fn {_coord, val} -> val == char end)
      |> Map.keys()
    end)
    |> Stream.flat_map(&find_antinodes/1)
    |> Stream.uniq()
    |> Stream.filter(&(&1 in Map.keys(grid)))
    |> Enum.count()
  end

  defp find_antinodes(antenna_coords) do
    run_on_pairs(antenna_coords, fn from, to ->
      slope = Grid.get_slope(from, to)

      Grid.get_neighbor(to, slope)
    end)
  end

  defp run_on_pairs(list, func) do
    for x <- list,
        y <- list,
        x != y do
      func.(x, y)
    end
  end

  def star_one_parser(_line) do
    :not_implemented
  end

  def star_two_parser(_line) do
    :not_implemented
  end
end
