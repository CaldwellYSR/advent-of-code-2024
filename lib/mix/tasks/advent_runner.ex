defmodule Mix.Tasks.AdventRunner do
  @moduledoc """
  Runs Advent Of Code Puzzles, can take arguments to run specific days or run all days with no arguments

  ```
  mix advent_runner all # Will run all existing puzzles to date
  mix advent_runner one # Will run day one
  mix advent_runner 1   # also works
  ```
  """
  use Mix.Task

  @shortdoc "Runs advent-of-code puzzles"
  def run(opts) do
    run_tasks(opts)
  end

  defp run_tasks([]) do
    one()
  end

  defp run_tasks(["all"]) do
    one()
  end

  defp run_tasks(["one"]), do: one()
  defp run_tasks(["1"]), do: one()

  defp one(), do: run_task(AdventOfCode.One)

  # defp two(), do: run_task(AdventOfCode.Two)

  defp run_task(module) do
    IO.puts("===== Day One ==============================================")
    IO.inspect(module.star_one(), label: "Star One: ")
    IO.inspect(module.star_two(), label: "Star Two: ")
    IO.puts("===== Day One ==============================================")
  end
end
