defmodule Aoc.Year2019.Day02.ProgramAlarmTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day02.ProgramAlarm, import: true

  alias Aoc.Year2019.Day02.ProgramAlarm

  describe "part_1/1" do
    test "examples" do
      assert "1,0,0,0,99" |> ProgramAlarm.part_1(0, 0) == 2
      assert "2,3,0,3,99" |> ProgramAlarm.part_1(3, 0) == 2
      assert "2,4,4,5,99,0" |> ProgramAlarm.part_1(4, 4) == 2
      assert "1,9,10,3,2,3,11,0,99,30,40,50" |> ProgramAlarm.part_1(9, 10) == 3500
      assert "1,1,1,4,99,5,6,0,99" |> ProgramAlarm.part_1(1, 1) == 30
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
