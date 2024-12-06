defmodule Mix.Tasks.AdventRunner do
  @moduledoc """
  Runs Advent Of Code Puzzles, can take arguments to run specific days or run all days with no arguments

  ```
  mix advent_runner       # Will run all existing puzzles to date
  mix advent_runner 1     # Runs a specific day
  mix advent_runner 1 2   # Runs multiple days
  ```
  """
  use Mix.Task

  @days %{
    "1" => AdventOfCode.Day.One,
    "2" => AdventOfCode.Day.Two,
    "3" => AdventOfCode.Day.Three,
    "4" => AdventOfCode.Day.Four,
    "5" => AdventOfCode.Day.Five,
    "6" => AdventOfCode.Day.Six,
    "7" => AdventOfCode.Day.Seven,
    "8" => AdventOfCode.Day.Eight,
    "9" => AdventOfCode.Day.Nine,
    "10" => AdventOfCode.Day.Ten,
    "11" => AdventOfCode.Day.Eleven,
    "12" => AdventOfCode.Day.Twelve,
    "13" => AdventOfCode.Day.Thirteen,
    "14" => AdventOfCode.Day.Fourteen,
    "15" => AdventOfCode.Day.Fifteen,
    "16" => AdventOfCode.Day.Sixteen,
    "17" => AdventOfCode.Day.Seventeen,
    "18" => AdventOfCode.Day.Eighteen,
    "19" => AdventOfCode.Day.Nineteen,
    "20" => AdventOfCode.Day.Twenty,
    "21" => AdventOfCode.Day.TwentyOne,
    "22" => AdventOfCode.Day.TwentyTwo,
    "23" => AdventOfCode.Day.TwentyThree,
    "24" => AdventOfCode.Day.TwentyFour,
    "25" => AdventOfCode.Day.TwentyFive
  }

  @shortdoc "Runs advent-of-code puzzles"
  def run([]), do: run_all()

  def run(opts) do
    Enum.each(opts, &run_task/1)
  end

  defp run_all() do
    Enum.each(modules_implementing_behaviour(AdventOfCode.Day), &run_task/1)
  end

  defp modules_implementing_behaviour(behaviour) do
    Mix.Task.run("loadpaths", [])

    Code.ensure_all_loaded(Map.values(@days))

    for {module, _} <- :code.all_loaded(),
        behaviours = module.module_info(:attributes)[:behaviour],
        behaviour in List.wrap(behaviours) do
      module
    end
  end

  defp run_task(number) when is_binary(number) do
    case Map.fetch(@days, number) do
      {:ok, module} -> run_task(module)
      _ -> IO.puts("Day #{number} Not Found")
    end
  end

  defp run_task(module) do
    IO.puts("===== #{module} ============================================")
    IO.inspect(module.star_one(), label: "Star One")
    IO.inspect(module.star_two(), label: "Star Two")
  end
end
