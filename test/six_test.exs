defmodule AdventOfCode.SixTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Six

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Six.star_one("test/six.txt") == 41
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Six.star_two("test/six.txt") == 6
    end
  end
end
