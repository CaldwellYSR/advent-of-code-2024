defmodule AdventOfCode do
  def read_input(file) do
    "#{Application.app_dir(:aoc_2024, "/priv/input/#{file}")}"
    |> File.stream!()
    |> Stream.map(&String.replace(&1, ~r/\r|\n/, ""))
  end

  def read_full_file(file) do
    "#{Application.app_dir(:aoc_2024, "/priv/input/#{file}")}"
    |> File.read!()
  end

  def read_file_to_grid(filename) do
    "#{Application.app_dir(:aoc_2024, "/priv/input/#{filename}")}"
    |> File.read!()
    |> to_grid()
  end

  def get_grid_size(grid) do
    keys = Map.keys(grid)
    {x_length, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, y_length} = Enum.max_by(keys, fn {_x, y} -> y end)
    {x_length, y_length}
  end

  def get_grid_neighbor({coord_x, coord_y}, {dir_x, dir_y}),
    do: {coord_x + dir_x, coord_y + dir_y}

  defp to_grid(file) do
    for {row, y} <- file |> String.split() |> Enum.with_index(),
        {char, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, char}
    end
  end
end
