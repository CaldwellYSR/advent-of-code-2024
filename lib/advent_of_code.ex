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

  defp to_grid(file) do
    for {row, y} <- file |> String.split() |> Enum.with_index(),
        {char, x} <- row |> String.graphemes() |> Enum.with_index(),
        into: %{} do
      {{x, y}, char}
    end
  end
end
