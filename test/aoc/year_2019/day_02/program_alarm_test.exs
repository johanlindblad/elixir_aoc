defmodule Aoc.Year2019.Day02.ProgramAlarmTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day02.ProgramAlarm, import: true

  alias Aoc.Year2019.Day02.ProgramAlarm

  describe "part_1/1" do
    test "examples" do
      assert ProgramAlarm.run_program(
               :array.from_list([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50])
             ) == 3500

      assert ProgramAlarm.run_program(:array.from_list([1, 1, 1, 4, 99, 5, 6, 0, 99])) == 30
    end

    @tag day: 02, year: 2019
    test "input", %{input: input} do
      assert input |> ProgramAlarm.part_1() == 3_267_740
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 02, year: 2019
    test "input", %{input: input} do
      assert input |> ProgramAlarm.part_2() == 7870
    end
  end
end
