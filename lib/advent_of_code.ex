defmodule AdventOfCode do
  def read_input(file) do
    "#{Application.app_dir(:aoc_2024, "/priv/input/#{file}")}"
    |> File.stream!()
    |> Stream.map(&String.replace(&1, ~r/\r|\n/, ""))
  end
end
