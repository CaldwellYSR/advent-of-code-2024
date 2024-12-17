defmodule AdventOfCode.ElevenTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Eleven

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Eleven.star_one("test/eleven.txt") == :not_implemented
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Eleven.star_two("test/eleven.txt") == :not_implemented
    end
  end
end
