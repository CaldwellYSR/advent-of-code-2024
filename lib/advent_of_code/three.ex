defmodule AdventOfCode.Three do
  def star_one(filename \\ "three.txt"), do: process_data(filename, &star_one_parser/1)
  def star_two(filename \\ "three.txt"), do: process_data(filename, &star_two_parser/1)

  def process_data(filename, parser) do
    filename
    |> AdventOfCode.read_input()
    |> Stream.flat_map(parser)
    |> Enum.sum()
  end

  defp star_one_parser(line) do
    ~r/mul\(([0-9]+),([0-9]+)\)/
    |> Regex.scan(line)
    |> run_commands()
  end

  defp star_two_parser(line) do
    {_command, output} =
      ~r/do\(\)|don\'t\(\)/
      |> Regex.split(line, include_captures: true)
      |> Enum.reduce({true, 0}, &process_line/2)

    [output]
  end

  defp process_line("don't()", {_, acc}), do: {false, acc}
  defp process_line("do()", {_, acc}), do: {true, acc}

  defp process_line(line, {true, acc}),
    do: {true, acc + Enum.sum(star_one_parser(line))}

  defp process_line(_line, state), do: state

  defp run_commands(commands) do
    commands
    |> Stream.map(fn [_mul, a, b] ->
      {a, _rem} = Integer.parse(a)
      {b, _rem} = Integer.parse(b)
      a * b
    end)
  end
end
