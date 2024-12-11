defmodule AdventOfCode.Day.Nine do
  alias AdventOfCode.Day

  @behaviour Day

  @impl Day
  def star_one(filename \\ "nine.txt"), do: process_file(filename, &star_one_parser/1)

  @impl Day
  def star_two(filename \\ "nine.txt"), do: process_file(filename, &star_two_parser/1)

  @impl Day
  def process_file(
        filename,
        parser
      ) do
    [out] =
      filename
      |> AdventOfCode.read_input()
      |> Enum.map(parser)

    out
  end

  def star_one_parser(line) do
    {_, data} =
      String.split(line, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce({0, ""}, fn {count, i}, {index, acc} ->
        {next_index, input} =
          case rem(i, 2) do
            0 -> {index + 1, "#{index}"}
            _ -> {index, "."}
          end

        acc = acc <> String.pad_trailing("", count, input)

        {next_index, acc}
      end)

    base = String.split(data, "", trim: true)

    dot = "."

    finish_index =
      base
      |> Enum.filter(fn c -> c != dot end)
      |> Enum.count()

    reversed = Enum.reverse(base)

    {transformed, _} =
      Enum.reduce_while(0..(finish_index - 1), {[], reversed}, fn index, {acc, reversed} ->
        c = Enum.at(base, index)

        case c do
          ^dot ->
            reverse_index = Enum.find_index(reversed, fn c -> c != dot end)
            {value, rest_reverse} = List.pop_at(reversed, reverse_index)

            {:cont, {acc ++ [value], rest_reverse}}

          _ ->
            {:cont, {acc ++ [c], reversed}}
        end
      end)

    transformed
    |> Enum.with_index()
    |> Enum.reduce(0, fn {id, index}, acc ->
      acc + index * String.to_integer(id)
    end)
  end

  def star_two_parser(_line) do
    :not_implemented
  end
end
