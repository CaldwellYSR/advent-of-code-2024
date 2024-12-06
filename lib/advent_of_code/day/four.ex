defmodule AdventOfCode.Day.Four do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "four.txt"), do: process_file(filename, &star_one_parser/1)
  @impl Day
  def star_two(filename \\ "four.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, parser) do
    grid =
      filename
      |> AdventOfCode.read_file_to_grid()

    apply(parser, [grid])
  end

  defp star_one_parser(grid) do
    start_locations = Map.filter(grid, fn {_location, val} -> val == "X" end)

    size = AdventOfCode.get_grid_size(grid)

    word = [next_char | rest_of_word] = ["M", "A", "S"]

    start_locations
    |> Enum.map(fn {coord, _char} ->
      coord
      |> get_neighbors(size, length(word))
      |> Enum.map(fn neighbor ->
        case Map.fetch(grid, neighbor) do
          {:ok, ^next_char} ->
            {neighbor, direction(neighbor, coord)}

          _ ->
            nil
        end
      end)
      |> Enum.reject(&is_nil/1)
    end)
    |> Enum.flat_map(fn letters_with_directions ->
      letters_with_directions
      |> Enum.map(fn {coord, direction} ->
        find_next_letter(grid, coord, direction, rest_of_word)
      end)
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.count()
  end

  defp star_two_parser(grid) do
    grid
    |> Enum.filter(fn {_, val} -> val == "A" end)
    |> Enum.count(fn {{x, y}, _} ->
      check_cross(grid, x, y)
    end)
  end

  defp check_cross(grid, x, y) do
    pattern1 = match_pattern(grid, x, y, [{"M", -1, -1}, {"M", -1, 1}, {"S", 1, -1}, {"S", 1, 1}])
    pattern2 = match_pattern(grid, x, y, [{"M", -1, -1}, {"S", -1, 1}, {"M", 1, -1}, {"S", 1, 1}])
    pattern3 = match_pattern(grid, x, y, [{"S", -1, -1}, {"S", -1, 1}, {"M", 1, -1}, {"M", 1, 1}])
    pattern4 = match_pattern(grid, x, y, [{"S", -1, -1}, {"M", -1, 1}, {"S", 1, -1}, {"M", 1, 1}])

    pattern1 or pattern2 or pattern3 or pattern4
  end

  defp match_pattern(grid, x, y, offsets) do
    Enum.all?(offsets, fn {expected_val, dx, dy} ->
      case Map.fetch(grid, {x + dx, y + dy}) do
        {:ok, ^expected_val} -> true
        _ -> false
      end
    end)
  end

  defp find_next_letter(grid, start_location, direction, word = [next_char | rest_of_word])
       when length(word) > 0 do
    neighbor = get_neighbor(start_location, direction)

    case Map.fetch(grid, neighbor) do
      {:ok, ^next_char} ->
        find_next_letter(grid, neighbor, direction, rest_of_word)

      _ ->
        nil
    end
  end

  defp find_next_letter(_grid, _start_location, _direction, _word) do
    :ok
  end

  defp get_neighbors({x, y}, {x_length, y_length}, word_length) do
    neighbors = []

    neighbors = if x - word_length >= 0, do: neighbors ++ [{x - 1, y}], else: neighbors
    neighbors = if x + word_length <= x_length, do: neighbors ++ [{x + 1, y}], else: neighbors
    neighbors = if y - word_length >= 0, do: neighbors ++ [{x, y - 1}], else: neighbors
    neighbors = if y + word_length <= y_length, do: neighbors ++ [{x, y + 1}], else: neighbors

    neighbors =
      if x - word_length >= 0 and y - word_length >= 0,
        do: neighbors ++ [{x - 1, y - 1}],
        else: neighbors

    neighbors =
      if x + word_length <= x_length and y + word_length <= y_length,
        do: neighbors ++ [{x + 1, y + 1}],
        else: neighbors

    neighbors =
      if y - word_length >= 0 and x + word_length <= x_length,
        do: neighbors ++ [{x + 1, y - 1}],
        else: neighbors

    neighbors =
      if y + word_length <= y_length and x - word_length >= 0,
        do: neighbors ++ [{x - 1, y + 1}],
        else: neighbors

    neighbors
  end

  defp direction({to_x, to_y}, {from_x, from_y}) do
    {to_x - from_x, to_y - from_y}
  end

  defp get_neighbor({coord_x, coord_y}, {dir_x, dir_y}) do
    {coord_x + dir_x, coord_y + dir_y}
  end
end
