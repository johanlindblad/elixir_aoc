defmodule Aoc.Year2019.Day07.AmplificationCircuitTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day07.AmplificationCircuit, import: true

  alias Aoc.Year2019.Day07.AmplificationCircuit

  describe "part_1/1" do
    test "examples" do
      program =
        "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> Arrays.new()

      assert AmplificationCircuit.run_1([[4, 3, 2, 1, 0]], program) == 43210
    end

    @tag day: 07, year: 2019
    test "input", %{input: input} do
      assert input |> AmplificationCircuit.part_1() == 14902
    end
  end

  describe "part_2/1" do
    test "examples" do
      input =
        "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"

      program =
        input
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> Arrays.new()

      assert AmplificationCircuit.run_loop([9, 8, 7, 6, 5], [
               program,
               program,
               program,
               program,
               program
             ]) == 139_629_729

      assert AmplificationCircuit.part_2(input) == 139_629_729
    end

    @tag day: 07, year: 2019
    test "input", %{input: input} do
      assert input |> AmplificationCircuit.part_2() == 6_489_132
    end
  end
end
