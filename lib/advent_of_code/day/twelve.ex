defmodule AdventOfCode.Day.Twelve do
  alias AdventOfCode.Day
  alias AdventOfCode.Grid

  @behaviour Day

  @impl Day
  def star_one(filename \\ "twelve.txt"), do: process_file(filename, &calculate_perimeter/1)

  @impl Day
  def star_two(filename \\ "twelve.txt"), do: process_file(filename, &calculate_bulk_perimeter/1)

  @impl Day
  def process_file(filename, parser) do
    grid = AdventOfCode.read_file_to_grid(filename)

    grid
    |> find_regions()
    |> Enum.reduce(0, fn region, acc ->
      area = Enum.count(region)
      perimeter = apply(parser, [region])

      acc + area * perimeter
    end)
  end

  def find_regions(grid) do
    {max_x, max_y} = Grid.get_size(grid)
    find_regions(grid, max_x, max_y, MapSet.new(), [])
  end

  defp find_regions(grid, max_x, max_y, visited, regions) do
    case find_unvisited(grid, visited) do
      nil ->
        regions

      start ->
        {new_visited, region} = flood_fill(grid, start, max_x, max_y, visited, [])
        find_regions(grid, max_x, max_y, new_visited, [region | regions])
    end
  end

  defp flood_fill(grid, {x, y}, max_x, max_y, visited, region) do
    if MapSet.member?(visited, {x, y}) do
      {visited, region}
    else
      letter = Map.get(grid, {x, y})
      new_visited = MapSet.put(visited, {x, y})
      new_region = [{x, y} | region]

      neighbors = [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]

      Enum.reduce(neighbors, {new_visited, new_region}, fn neighbor, {acc_visited, acc_region} ->
        if valid_neighbor?(grid, neighbor, max_x, max_y, letter) do
          flood_fill(grid, neighbor, max_x, max_y, acc_visited, acc_region)
        else
          {acc_visited, acc_region}
        end
      end)
    end
  end

  defp find_unvisited(grid, visited) do
    Enum.find(Map.keys(grid), fn pos -> not MapSet.member?(visited, pos) end)
  end

  defp valid_neighbor?(grid, {x, y}, max_x, max_y, letter) do
    x >= 0 and x <= max_x and y >= 0 and y <= max_y and
      Map.get(grid, {x, y}) == letter
  end

  defp calculate_perimeter(region) do
    region_set = MapSet.new(region)
    total_sides = length(region) * 4

    shared_sides =
      Enum.reduce(region, 0, fn {x, y}, acc ->
        neighbors = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
        shared = Enum.count(neighbors, &MapSet.member?(region_set, &1))
        acc + shared
      end)

    total_sides - shared_sides
  end

  def calculate_bulk_perimeter(region) do
    {min_x, max_x} = Enum.map(region, fn {x, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = Enum.map(region, fn {_, y} -> y end) |> Enum.min_max()

    region_set = MapSet.new(region)

    Enum.reduce(region, 0, fn {x, y}, acc ->
      neighbors = [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]

      exposed_sides =
        Enum.count(neighbors, fn neighbor ->
          not MapSet.member?(region_set, neighbor) and
            (elem(neighbor, 0) < min_x or elem(neighbor, 0) > max_x or
               elem(neighbor, 1) < min_y or elem(neighbor, 1) > max_y)
        end)

      acc + exposed_sides
    end)
  end
end
