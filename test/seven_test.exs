defmodule AdventOfCode.SevenTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Seven

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Seven.star_one("test/seven.txt") == 3749
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Seven.star_two("test/seven.txt") == 11387
    end
  end
end
