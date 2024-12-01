defmodule AdventOfCode do
  def read_input(file) do
    "#{Application.app_dir(:aoc_2024, "/priv/input/#{file}")}"
    |> File.stream!()
  end
end
