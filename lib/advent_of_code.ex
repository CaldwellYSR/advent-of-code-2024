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
    |> AdventOfCode.Grid.to_grid()
  end
end
