defmodule AdventOfCode.ElevenTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Eleven

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Eleven.star_one("test/eleven.txt") == 55312
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Eleven.star_two("test/eleven.txt") == 65_601_038_650_482
    end
  end
end
