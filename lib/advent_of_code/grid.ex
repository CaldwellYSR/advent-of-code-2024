defmodule AdventOfCode.Grid do
  def get_size(grid) do
    keys = Map.keys(grid)
    {x_length, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, y_length} = Enum.max_by(keys, fn {_x, y} -> y end)
    {x_length, y_length}
  end

  def get_slope({from_x, from_y}, {to_x, to_y}),
    do: {to_x - from_x, to_y - from_y}

  def get_neighbor({coord_x, coord_y}, {dir_x, dir_y}),
    do: {coord_x + dir_x, coord_y + dir_y}

  def to_grid(file) do
    for {row, y} <- file |> String.split() |> Enum.with_index(),
        {char, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, char}
    end
  end

  def to_integer_grid!(file) do
    for {row, y} <- file |> String.split() |> Enum.with_index(),
        {char, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, String.to_integer(char)}
    end
  end

  def cardinal_directions() do
    [
      {1, 0},
      {0, 1},
      {-1, 0},
      {0, -1}
    ]
  end

  def visualize(grid) do
    {width, height} = get_size(grid)

    IO.puts("\n")

    Enum.each(0..width, fn y ->
      Enum.reduce(0..height, "", fn x, acc ->
        acc <> "#{Map.fetch!(grid, {x, y})}"
      end)
      |> IO.inspect()
    end)

    grid
  end
end
