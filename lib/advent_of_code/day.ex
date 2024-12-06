defmodule AdventOfCode.Day do
  @callback star_one(String.t()) :: integer
  @callback star_two(String.t()) :: integer

  @callback process_file(String.t(), (... -> any)) :: integer
end
