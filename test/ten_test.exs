defmodule AdventOfCode.TenTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Ten

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Ten.star_one("test/ten.txt") == :not_implemented
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Ten.star_two("test/ten.txt") == :not_implemented
    end
  end
end
