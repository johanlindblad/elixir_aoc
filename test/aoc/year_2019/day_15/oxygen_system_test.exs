defmodule Aoc.Year2019.Day15.OxygenSystemTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day15.OxygenSystem, import: true

  alias Aoc.Year2019.Day15.OxygenSystem

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 15, year: 2019
    test "input", %{input: input} do
      assert input |> OxygenSystem.part_1() == 280
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 15, year: 2019
    test "input", %{input: input} do
      assert input |> OxygenSystem.part_2() == 400
    end
  end
end
