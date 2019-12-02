defmodule Aoc.Year2019.Day02.ProgramAlarmTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day02.ProgramAlarm, import: true

  alias Aoc.Year2019.Day02.ProgramAlarm

  describe "part_1/1" do
    test "examples" do
      assert ProgramAlarm.run_program([1,9,10,3,2,3,11,0,99,30,40,50]) == [3500,9,10,70,2,3,11,0,99,30,40,50]
      assert ProgramAlarm.run_program([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
    end

    test "setting" do
      assert ProgramAlarm.set([0,1,2,3,4,5,6], 3, 5) == [0,1,2,5,4,5,6]
      assert ProgramAlarm.set([0,1,2,3,4,5,6], 0, 5) == [5,1,2,3,4,5,6]
    end

    @tag day: 02, year: 2019
    test "input", %{input: input} do
      assert input |> ProgramAlarm.part_1() == 3267740
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
