defmodule Aoc.Year2019.Day05.SunnywithaChanceofAsteroidsTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day05.SunnywithaChanceofAsteroids, import: true

  alias Aoc.Year2019.Day05.SunnywithaChanceofAsteroids

  describe "part_1/1" do
    test "examples" do
      assert "1002,4,3,4,33" |> SunnywithaChanceofAsteroids.part_1() == []
    end

    @tag day: 05, year: 2019
    test "input", %{input: input} do
      assert input |> SunnywithaChanceofAsteroids.part_1() == 6_745_903
    end
  end

  describe "part_2/1" do
    test "examples" do
      assert SunnywithaChanceofAsteroids.part_2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9") == 1

      input =
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

      assert SunnywithaChanceofAsteroids.part_2(input) == 999
    end

    @tag day: 05, year: 2019
    test "input", %{input: input} do
      assert input |> SunnywithaChanceofAsteroids.part_2() == 9_168_267
    end
  end
end
