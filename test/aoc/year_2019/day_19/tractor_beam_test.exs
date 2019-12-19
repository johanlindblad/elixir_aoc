defmodule Aoc.Year2019.Day19.TractorBeamTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day19.TractorBeam, import: true

  alias Aoc.Year2019.Day19.TractorBeam

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 19, year: 2019
    test "input", %{input: input} do
      assert input |> TractorBeam.part_1() == 150
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 19, year: 2019
    test "input", %{input: input} do
      assert input |> TractorBeam.part_2() == 12_201_460
    end
  end
end
