defmodule Aoc.Year2019.Day01.TheTyrannyoftheRocketEquationTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day01.TheTyrannyoftheRocketEquation, import: true

  alias Aoc.Year2019.Day01.TheTyrannyoftheRocketEquation

  describe "part_1/1" do
    test "examples" do
      assert TheTyrannyoftheRocketEquation.module_fuel_required(12) == 2
      assert TheTyrannyoftheRocketEquation.module_fuel_required(14) == 2
      assert TheTyrannyoftheRocketEquation.module_fuel_required(1969) == 654
      assert TheTyrannyoftheRocketEquation.module_fuel_required(100_756) == 33583
    end

    @tag day: 01, year: 2019
    test "input", %{input: input} do
      assert input |> TheTyrannyoftheRocketEquation.part_1() == 3_334_297
    end
  end

  describe "part_2/1" do
    test "examples" do
      assert TheTyrannyoftheRocketEquation.module_fuel_required_inclusive(12) == 2
      assert TheTyrannyoftheRocketEquation.module_fuel_required_inclusive(1969) == 966
      assert TheTyrannyoftheRocketEquation.module_fuel_required_inclusive(100_756) == 50346
    end

    @tag day: 01, year: 2019
    test "input", %{input: input} do
      assert input |> TheTyrannyoftheRocketEquation.part_2() == 4_998_565
    end
  end
end
