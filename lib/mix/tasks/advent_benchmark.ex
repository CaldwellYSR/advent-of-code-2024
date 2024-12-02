defmodule Mix.Tasks.AdventBenchmark do
  @moduledoc """
  Runs Benchee on puzzle solutions, can take arguments to run specific days or run all days with no arguments

  ```
  mix advent_benchmark all # Will run all existing puzzles to date
  mix advent_benchmark one # Will run day one
  mix advent_benchmark 1   # also works
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

  defp one(), do: run_task(AdventOfCode.One, "One")

  # defp two(), do: run_task(AdventOfCode.Two)

  defp run_task(module, day) do
    IO.puts("===== Day #{day} ============================================")

    Benchee.run(%{
      "star_one" => fn -> module.star_one() end,
      "star_two" => fn -> module.star_two() end
    })
  end
end
