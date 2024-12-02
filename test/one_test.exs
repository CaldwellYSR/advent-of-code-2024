defmodule AdventOfCode.OneTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.One

  describe "star_one/1" do
    test "given test data, return test output" do
      assert One.star_one("test/one.txt") == 11
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert One.star_two("test/one.txt") == 31
    end
  end
end
