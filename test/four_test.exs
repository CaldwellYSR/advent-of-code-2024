defmodule AdventOfCode.FourTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Four

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Four.star_one("test/four.txt") == 18
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Four.star_two("test/four.txt") == 9
    end
  end
end
