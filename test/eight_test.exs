defmodule AdventOfCode.EightTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Eight

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Eight.star_one("test/eight.txt") == 14
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Eight.star_two("test/eight.txt") == 34
    end
  end
end
