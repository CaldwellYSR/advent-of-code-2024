defmodule Mix.Tasks.Advent.Gen.Day do
  use Mix.Task

  @shortdoc "Generates an Advent of Code Day module"

  def run([filename]) do
    name = String.capitalize(filename)

    module_content = """
    defmodule AdventOfCode.#{name} do
      def star_one(filename \\\\ "#{filename}.txt"), do: process_file(filename)

      def star_two(filename \\\\ "#{filename}.txt"), do: process_file(filename)

      defp process_file(filename) do
        AdventOfCode.read_input(filename)
      end
    end
    """

    test_content = """
    defmodule AdventOfCode.#{name}Test do
      use ExUnit.Case
      doctest AdventOfCode

      alias AdventOfCode.#{name}

      describe "star_one/1" do
        test "given test data, return test output" do
          assert #{name}.star_one("test/#{filename}.txt") == :not_implemented
        end
      end

      describe "star_two/1" do
        test "given test data, return test output" do
          assert #{name}.star_two("test/#{filename}.txt") == :not_implemented
        end
      end
    end
    """

    File.write!("lib/#{filename}.ex", module_content)
    File.write!("test/#{filename}_test.exs", test_content)
    File.write!("priv/input/#{filename}.txt", "")
    File.write!("priv/input/test/#{filename}.txt", "")
    IO.puts("Generated lib/#{filename}.ex module")
    IO.puts("Generated test/#{filename}_test.exs module")
    IO.puts("Generated priv/input/test/#{filename}.txt for test data")
    IO.puts("Generated priv/input/#{filename}.txt for puzzle data")
  end

  def run(_) do
    IO.puts("Usage: mix advent.gen.day <filename>")
  end
end
