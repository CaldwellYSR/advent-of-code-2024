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
  def run([]), do: run_all()

  def run(opts) do
    Enum.each(opts, &run_task/1)
  end

  defp run_all() do
    one()
    two()
    three()
    four()
  end

  defp run_task("one"), do: one()
  defp run_task("1"), do: one()
  defp run_task("two"), do: two()
  defp run_task("2"), do: two()
  defp run_task("three"), do: three()
  defp run_task("3"), do: three()
  defp run_task("four"), do: four()
  defp run_task("4"), do: four()

  defp one(), do: run_task(AdventOfCode.One, "One")
  defp two(), do: run_task(AdventOfCode.Two, "Two")
  defp three(), do: run_task(AdventOfCode.Three, "Three")
  defp four(), do: run_task(AdventOfCode.Four, "Four")

  defp run_task(module, day) do
    IO.puts("===== Day #{day} ============================================")

    Benchee.run(%{
      "star_one" => fn -> module.star_one() end,
      "star_two" => fn -> module.star_two() end
    })
  end
end
