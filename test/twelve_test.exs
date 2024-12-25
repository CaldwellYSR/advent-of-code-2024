defmodule AdventOfCode.TwelveTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Twelve

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Twelve.star_one("test/twelve.txt") == 1930
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Twelve.star_two("test/twelve.txt") == 1206
    end
  end
end
