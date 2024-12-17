defmodule AdventOfCode.Day.Eleven do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "eleven.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "eleven.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(filename, parser) do
    line =
      filename
      |> AdventOfCode.read_full_file()
      |> String.replace("\n", "")
      |> String.split(" ", trim: true)

    Enum.scan(0..24, line, fn _, last_line ->
      Enum.flat_map(last_line, parser)
    end)
    |> List.last()
    |> Enum.count()
  end

  def star_one_parser("0"), do: ["1"]
  def star_one_parser("1"), do: ["2024"]

  def star_one_parser(val) do
    str_len = String.length(val)

    if rem(str_len, 2) == 0 do
      {left, right} = String.split_at(val, floor(str_len / 2))

      right =
        case String.trim_leading(right, "0") do
          "" -> "0"
          s -> s
        end

      [left, right]
    else
      ["#{String.to_integer(val) * 2024}"]
    end
  end

  def star_two_parser(_line) do
    :not_implemented
  end
end
