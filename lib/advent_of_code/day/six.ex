defmodule AdventOfCode.Day.Six do
  alias AdventOfCode.Day

  @guard_directions %{
    "^" => {0, -1},
    ">" => {1, 0},
    "V" => {0, 1},
    "<" => {-1, 0}
  }

  @turns %{
    {0, -1} => {1, 0},
    {1, 0} => {0, 1},
    {0, 1} => {-1, 0},
    {-1, 0} => {0, -1}
  }

  @guard_direction_options ["^", ">", "V", "<"]
  @replacing_char "X"

  @obstacle "#"

  @behaviour Day

  @impl Day
  def star_one(filename \\ "six.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "six.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, parser) do
    grid = AdventOfCode.read_file_to_grid(filename)

    apply(parser, [grid])
  end

  def star_one_parser(grid) do
    {start_coord, guard_facing} =
      Enum.find(grid, fn {_coord, val} -> val in @guard_direction_options end)

    direction = Map.fetch!(@guard_directions, guard_facing)

    {_, grid} = Map.get_and_update(grid, start_coord, fn s -> {s, @replacing_char} end)

    grid
    |> check_neighbor(start_coord, direction)
    |> Map.values()
    |> Enum.count(fn val -> val == @replacing_char end)
  end

  defp check_neighbor(grid, start, direction) do
    obstacle = @obstacle
    neighbor = AdventOfCode.Grid.get_neighbor(start, direction)

    case Map.get_and_update(grid, neighbor, fn
           nil -> :pop
           ^obstacle -> {:halt, @obstacle}
           val -> {val, @replacing_char}
         end) do
      {nil, grid} -> grid
      {:halt, grid} -> check_neighbor(grid, start, @turns[direction])
      {_, grid} -> check_neighbor(grid, neighbor, direction)
    end
  end

  def star_two_parser(_grid) do
    0
  end
end
