defmodule AdventOfCode.TwoTest do
  use ExUnit.Case
  doctest AdventOfCode

  alias AdventOfCode.Day.Two

  describe "star_one/1" do
    test "given test data, return test output" do
      assert Two.star_one("test/two.txt") == 2
    end
  end

  describe "is_line_safe/1" do
    test "given a list of integers that decrease only by 1 or 2, returns 1" do
      input = [7, 6, 4, 2, 1]

      assert 1 == Two.is_line_safe(input)
    end

    test "given a list of integers that have a +5 change, returns 0" do
      input = [1, 2, 7, 8, 9]

      assert 0 == Two.is_line_safe(input)
    end

    test "given a list of integers that have a -4 change, returns 0" do
      input = [9, 7, 6, 2, 1]

      assert 0 == Two.is_line_safe(input)
    end

    test "given a list of integers that increase and decrease, returns 0" do
      input = [1, 3, 2, 4, 5]

      assert 0 == Two.is_line_safe(input)
    end

    test "given a list of integers that have equal numbers, returns 0" do
      input = [8, 6, 4, 4, 1]

      assert 0 == Two.is_line_safe(input)
    end

    test "given a safe list of integers, returns 1" do
      input = [1, 3, 6, 7, 9]

      assert 1 == Two.is_line_safe(input)
    end
  end

  describe "is_line_safe_with_removals/1" do
    test "given a list of integers that decrease only by 1 or 2, returns 1" do
      input = [7, 6, 4, 2, 1]

      assert 1 == Two.is_line_safe_with_removals(input)
    end

    test "given a list of integers that have a +5 change, returns 0" do
      input = [1, 2, 7, 8, 9]

      assert 0 == Two.is_line_safe_with_removals(input)
    end

    test "given a list of integers that have a -4 change, returns 0" do
      input = [9, 7, 6, 2, 1]

      assert 0 == Two.is_line_safe_with_removals(input)
    end

    test "given a list of integers that increase and decrease, returns 0" do
      input = [1, 3, 2, 4, 5]

      assert 1 == Two.is_line_safe_with_removals(input)
    end

    test "given a list of integers that have equal numbers, returns 0" do
      input = [8, 6, 4, 4, 1]

      assert 1 == Two.is_line_safe_with_removals(input)
    end

    test "given a safe list of integers, returns 1" do
      input = [1, 3, 6, 7, 9]

      assert 1 == Two.is_line_safe_with_removals(input)
    end
  end

  describe "star_two/1" do
    test "given test data, return test output" do
      assert Two.star_two("test/two.txt") == 4
    end
  end
end
