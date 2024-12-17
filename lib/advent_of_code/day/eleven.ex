defmodule AdventOfCode.Day.Eleven do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "eleven.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "eleven.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, _parser) do
    AdventOfCode.read_input(filename)

    0
  end

  def star_one_parser(_line) do
    :not_implemented
  end

  def star_two_parser(_line) do
    :not_implemented
  end
end
