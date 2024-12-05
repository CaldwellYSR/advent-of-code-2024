defmodule AdventOfCode.<%= inspect String.capitalize(day) %> do
  def star_one(filename \\ <%= inspect "#{day}.txt" %>), do: process_data(filename, &star_one_parser/1)
  def star_two(filename \\ <%= inspect "#{day}.txt" %>), do: process_data(filename, &star_two_parser/1)

  def process_data(filename, parser) do
    filename
    |> AdventOfCode.read_input()
    |> Stream.map(parser)
    |> Enum.sum()
  end

  defp star_one_parser(line) do
  end

  defp star_two_parser(line) do
  end

end
