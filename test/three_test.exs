defmodule AdventOfCode.ThreeTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Three

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Three.star_one("test/three.txt") == 161
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Three.star_two("test/three-two.txt") == 48
    end
  end
end
