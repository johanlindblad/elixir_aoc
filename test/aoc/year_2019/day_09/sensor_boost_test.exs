defmodule Aoc.Year2019.Day09.SensorBoostTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day09.SensorBoost, import: true

  alias Aoc.Year2019.Day09.SensorBoost

  describe "part_1/1" do
    test "examples" do
      quine = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

      assert quine |> SensorBoost.part_1() == [
               109,
               1,
               204,
               -1,
               1001,
               100,
               1,
               100,
               1008,
               100,
               16,
               101,
               1006,
               101,
               0,
               99
             ]

      number = "1102,34915192,34915192,7,4,7,99,0"
      assert number |> SensorBoost.part_1() == [1_219_070_632_396_864]
      number2 = "104,1125899906842624,99"
      assert number2 |> SensorBoost.part_1() == [1_125_899_906_842_624]

      input =
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

      assert SensorBoost.part_1(input) == [999]
    end

    @tag day: 09, year: 2019
    test "input", %{input: input} do
      assert input |> SensorBoost.part_1() == [3_765_554_916]
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 09, year: 2019
    test "input", %{input: input} do
      assert input |> SensorBoost.part_2() == [76642]
    end
  end
end
