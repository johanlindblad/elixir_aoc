defmodule Aoc.Year2019.Day13.CarePackageTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day13.CarePackage, import: true

  alias Aoc.Year2019.Day13.CarePackage

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 13, year: 2019
    test "input", %{input: input} do
      assert input |> CarePackage.part_1() == 320
    end
  end

  describe "part_2/1" do
    test "examples" do
    end

    @tag day: 13, year: 2019, timeout: :infinity
    test "input", %{input: input} do
      assert input |> CarePackage.part_2() == 15156
    end
  end
end
