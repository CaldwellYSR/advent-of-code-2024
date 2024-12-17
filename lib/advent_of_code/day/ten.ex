defmodule AdventOfCode.Day.Ten do
  alias AdventOfCode.Day
  alias AdventOfCode.Grid

  @behaviour Day

  @impl Day
  def star_one(filename \\ "ten.txt"), do: process_file(filename, &star_one_parser/2)

  @impl Day
  def star_two(filename \\ "ten.txt"), do: process_file(filename, &star_two_parser/2)

  @impl Day
  def process_file(filename, parser) do
    grid = AdventOfCode.read_file_to_integer_grid(filename)

    grid
    |> Map.filter(fn {_key, val} -> val == 0 end)
    |> Map.keys()
    |> Enum.map(fn coord ->
      apply(parser, [grid, coord])
    end)
    |> Enum.sum()
  end

  defp score_trailhead(_grid, start_coord, 9) do
    [start_coord]
  end

  defp score_trailhead(grid, start_coord, start_value) do
    Enum.flat_map(Grid.cardinal_directions(), fn dir ->
      neighbor = Grid.get_neighbor(start_coord, dir)

      case Map.fetch(grid, neighbor) do
        :error ->
          []

        {:ok, neighbor_value} ->
          if neighbor_value - start_value == 1 do
            score_trailhead(grid, neighbor, neighbor_value)
          else
            []
          end
      end
    end)
  end

  def star_one_parser(grid, coord) do
    grid
    |> score_trailhead(coord, Map.fetch!(grid, coord))
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.count()
  end

  def star_two_parser(grid, coord) do
    grid
    |> score_trailhead(coord, Map.fetch!(grid, coord))
    |> Enum.count()
  end
end
