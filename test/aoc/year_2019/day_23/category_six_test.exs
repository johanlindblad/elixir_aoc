defmodule Aoc.Year2019.Day23.CategorySixTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day23.CategorySix, import: true

  alias Aoc.Year2019.Day23.CategorySix

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 23, year: 2019
    test "input", %{input: input} do
      assert input |> CategorySix.part_1() == 18513
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 23, year: 2019
    test "input", %{input: input} do
      assert input |> CategorySix.part_2() == 13286
    end
  end
end
