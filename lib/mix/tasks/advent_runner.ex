defmodule Mix.Tasks.AdventRunner do
  @moduledoc """
  Runs Advent Of Code Puzzles, can take arguments to run specific days or run all days with no arguments

  ```
  mix advent_runner all # Will run all existing puzzles to date
  mix advent_runner one # Will run day one
  mix advent_runner 1   # also works
  mix advent_runner 1 2   # also works
  ```
  """
  use Mix.Task

  @shortdoc "Runs advent-of-code puzzles"
  def run([]), do: run_tasks(["all"])

  def run(opts) do
    Enum.each(opts, &run_task/1)
  end

  defp run_tasks(["all"]) do
    one()
    two()
    three()
  end

  defp run_task("one"), do: one()
  defp run_task("1"), do: one()
  defp run_task("two"), do: two()
  defp run_task("2"), do: two()
  defp run_task("three"), do: three()
  defp run_task("3"), do: three()

  defp one(), do: run_task(AdventOfCode.One, "One")
  defp two(), do: run_task(AdventOfCode.Two, "Two")
  defp three(), do: run_task(AdventOfCode.Three, "Three")

  defp run_task(module, day) do
    IO.puts("===== Day #{day} ============================================")
    IO.inspect(module.star_one(), label: "Star One: ")
    IO.inspect(module.star_two(), label: "Star Two: ")
  end
end
