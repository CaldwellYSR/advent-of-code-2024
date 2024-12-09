defmodule AdventOfCode.Day.Eight do
  alias AdventOfCode.Day
  alias AdventOfCode.Grid

  @behaviour Day

  @impl Day
  def star_one(filename \\ "eight.txt"), do: process_file(filename, &star_one_parser/2)

  @impl Day
  def star_two(filename \\ "eight.txt"), do: process_file(filename, &star_two_parser/2)

  @impl Day
  def process_file(filename, parser) do
    grid = AdventOfCode.read_file_to_grid(filename)

    size = Grid.get_size(grid)

    grid
    |> Map.values()
    |> Stream.uniq()
    |> Stream.reject(&(&1 == "."))
    |> Stream.map(fn char ->
      grid
      |> Map.filter(fn {_coord, val} -> val == char end)
      |> Map.keys()
    end)
    |> Stream.flat_map(fn antenna_coords ->
      apply(parser, [antenna_coords, size])
    end)
    |> Stream.uniq()
    |> Stream.filter(&(&1 in Map.keys(grid)))
    |> Enum.count()
  end

  defp star_one_parser(antenna_coords, _size) do
    run_on_pairs(antenna_coords, fn from, to ->
      slope = Grid.get_slope(from, to)

      Grid.get_neighbor(to, slope)
    end)
  end

  defp star_two_parser(antenna_coords, {size_x, size_y}) do
    run_on_pairs(antenna_coords, fn from, to ->
      slope = Grid.get_slope(from, to)

      Stream.iterate(from, fn coord ->
        Grid.get_neighbor(coord, slope)
      end)
      |> Enum.reduce_while([], fn coord = {cx, cy}, acc ->
        if cx > size_x or cy > size_y or cx < 0 or cy < 0 do
          {:halt, acc}
        else
          {:cont, acc ++ [coord]}
        end
      end)
    end)
    |> List.flatten()
  end

  defp run_on_pairs(list, func) do
    for x <- list,
        y <- list,
        x != y do
      func.(x, y)
    end
  end
end
