defmodule AdventOfCode.Grid do
  def get_size(grid) do
    keys = Map.keys(grid)
    {x_length, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, y_length} = Enum.max_by(keys, fn {_x, y} -> y end)
    {x_length, y_length}
  end

  def get_neighbor({coord_x, coord_y}, {dir_x, dir_y}),
    do: {coord_x + dir_x, coord_y + dir_y}

  def to_grid(file) do
    for {row, y} <- file |> String.split() |> Enum.with_index(),
        {char, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, char}
    end
  end
end
