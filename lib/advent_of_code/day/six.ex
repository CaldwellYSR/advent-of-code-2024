defmodule AdventOfCode.Day.Six do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "six.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "six.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, _parser) do
    AdventOfCode.read_input(filename)

    0
  end

  def star_one_parser(_line) do
    0
  end

  def star_two_parser(_line) do
    0
  end
end
