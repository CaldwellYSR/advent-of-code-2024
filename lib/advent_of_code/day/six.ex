defmodule AdventOfCode.Day.Six do
  alias AdventOfCode.Day

  alias AdventOfCode.Grid

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
  @turn_char "+"

  @directions [
    left: {-1, 0},
    up: {0, -1},
    right: {1, 0},
    down: {0, 1}
  ]

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

  defp check_neighbor(grid, start, direction, turn_char \\ @replacing_char) do
    obstacle = @obstacle
    neighbor = Grid.get_neighbor(start, direction)

    case Map.get_and_update(grid, neighbor, fn
           nil -> :pop
           ^obstacle -> {:halt, @obstacle}
           val -> {val, @replacing_char}
         end) do
      {nil, grid} ->
        grid

      {:halt, grid} ->
        grid
        |> Map.update!(start, fn _ -> turn_char end)
        |> check_neighbor(start, @turns[direction], turn_char)

      {_, grid} ->
        grid
        |> check_neighbor(neighbor, direction, turn_char)
    end
  end

  def star_two_parser(grid) do
    {start_coord, guard_facing} =
      Enum.find(grid, fn {_coord, val} -> val in @guard_direction_options end)

    direction = Map.fetch!(@guard_directions, guard_facing)

    {_, grid} = Map.get_and_update(grid, start_coord, fn s -> {s, @replacing_char} end)

    grid =
      check_neighbor(grid, start_coord, direction, @turn_char)

    {corners, path} = find_corners_and_path(grid)
    find_potential_loops(corners, path)
  end

  defp find_corners_and_path(grid) do
    path =
      grid
      |> Map.filter(fn {_coord, val} -> val == @replacing_char or val == @turn_char end)
      |> Map.keys()

    corners = %{left: [], up: [], right: [], down: []}

    corners =
      grid
      |> Map.filter(fn {_coord, val} -> val == @turn_char end)
      |> Enum.reduce(corners, fn {coord, _val}, acc ->
        Map.merge(acc, find_obstacle(grid, coord), fn _key, l1, l2 -> l1 ++ l2 end)
      end)

    {corners, path}
  end

  defp find_obstacle(grid, coord) do
    Enum.reduce(@directions, %{}, fn {key, direction}, acc ->
      neighbor = Grid.get_neighbor(coord, direction)

      if Map.get(grid, neighbor) == @obstacle do
        Map.update(acc, key, [coord], &[coord | &1])
      else
        acc
      end
    end)
  end

  defp find_potential_loops(corners, path) do
    missing_left =
      find_missing_left(corners)
      |> Enum.map(fn {{up_x, _}, _, {_, down_y}} ->
        {up_x, down_y}
      end)
      |> Enum.filter(fn potential_left ->
        potential_left in path
      end)

    missing_right =
      corners
      |> find_missing_right()
      |> Enum.map(fn {{down_x, _}, _, {_, up_y}} ->
        {down_x, up_y}
      end)
      |> Enum.filter(fn potential_right ->
        potential_right in path
      end)

    missing_up =
      corners
      |> find_missing_up()
      |> Enum.map(fn {{_, right_y}, _, {left_x, _}} ->
        {left_x, right_y}
      end)
      |> Enum.filter(fn potential_up ->
        potential_up in path
      end)

    missing_down =
      corners
      |> find_missing_down()
      |> Enum.map(fn {{_, left_y}, _, {right_x, _}} ->
        {right_x, left_y}
      end)
      |> Enum.filter(fn potential_down ->
        potential_down in path
      end)

    List.flatten([missing_left, missing_right, missing_up, missing_down])
    |> Enum.count()
  end

  defp find_missing_left(%{up: up, right: right, down: down}) do
    Enum.flat_map(up, fn up_coord = {_up_x, up_y} ->
      matching_right =
        Enum.filter(right, fn {_, right_y} ->
          right_y == up_y
        end)

      matching_right
      |> Enum.flat_map(fn right_coord = {right_x, _} ->
        matching_down = Enum.filter(down, fn {down_x, _} -> down_x == right_x end)

        matching_down
        |> Enum.map(fn down_coord ->
          {up_coord, right_coord, down_coord}
        end)
      end)
    end)
  end

  defp find_missing_right(%{up: up, left: left, down: down}) do
    Enum.flat_map(down, fn down_coord = {_down_x, down_y} ->
      matching_left =
        Enum.filter(left, fn {_, left_y} ->
          left_y == down_y
        end)

      matching_left
      |> Enum.flat_map(fn left_coord = {left_x, _} ->
        matching_up = Enum.filter(up, fn {up_x, _} -> up_x == left_x end)

        matching_up
        |> Enum.map(fn up_coord ->
          {down_coord, left_coord, up_coord}
        end)
      end)
    end)
  end

  defp find_missing_up(%{right: right, left: left, down: down}) do
    Enum.flat_map(right, fn right_coord = {right_x, _right_y} ->
      matching_down =
        Enum.filter(down, fn {down_x, _} ->
          down_x == right_x
        end)

      matching_down
      |> Enum.flat_map(fn down_coord = {_, down_y} ->
        matching_left = Enum.filter(left, fn {_, left_y} -> left_y == down_y end)

        matching_left
        |> Enum.map(fn left_coord ->
          {right_coord, down_coord, left_coord}
        end)
      end)
    end)
  end

  defp find_missing_down(%{right: right, left: left, up: up}) do
    Enum.flat_map(left, fn left_coord = {left_x, _left_y} ->
      matching_up =
        Enum.filter(up, fn {up_x, _} ->
          up_x == left_x
        end)

      matching_up
      |> Enum.flat_map(fn up_coord = {_, up_y} ->
        matching_right = Enum.filter(right, fn {_, right_y} -> right_y == up_y end)

        matching_right
        |> Enum.map(fn right_coord ->
          {left_coord, up_coord, right_coord}
        end)
      end)
    end)
  end
end
