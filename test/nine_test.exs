defmodule AdventOfCode.NineTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Nine

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Nine.star_one("test/nine.txt") == 1928
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Nine.star_two("test/nine.txt") == :not_implemented
    end
  end
end
