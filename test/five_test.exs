defmodule AdventOfCode.FiveTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Five

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Five.star_one("test/five.txt") == 143
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Five.star_two("test/five.txt") == 123
    end
  end
end
