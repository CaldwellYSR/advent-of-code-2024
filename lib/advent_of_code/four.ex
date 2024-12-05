defmodule AdventOfCode.Four do
  def star_one(filename \\ "four.txt"), do: process_data(filename, &star_one_parser/4)
  def star_two(filename \\ "four.txt"), do: process_data(filename, &star_two_parser/2)

  def process_data(filename, parser) do
    grid =
      filename
      |> AdventOfCode.read_full_file()
      |> to_grid()

    start_locations = Map.filter(grid, fn {_location, val} -> val == "X" end)

    keys = Map.keys(grid)
    {x_length, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, y_length} = Enum.max_by(keys, fn {x, _y} -> x end)

    apply(parser, [grid, start_locations, ["M", "A", "S"], {x_length, y_length}])
  end

  defp star_two_parser(line, grid) do
  end

  defp to_grid(grid) do
    for {row, i} <- grid |> String.split() |> Enum.with_index(),
        {char, j} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{j, i}, char}
    end
  end

  defp star_one_parser(grid, start_locations, word = [next_char | rest_of_word], size) do
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
