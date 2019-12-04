defmodule Aoc.Year2019.Day04.SecureContainerTest do
  use Aoc.DayCase
  doctest Aoc.Year2019.Day04.SecureContainer, import: true

  alias Aoc.Year2019.Day04.SecureContainer

  describe "part_1/1" do
    test "examples" do
    end

    @tag day: 04, year: 2019
    test "input", %{input: input} do
      assert input |> SecureContainer.part_1() == 1694
    end
  end

  describe "part_2/1" do
    test "examples" do
      assert SecureContainer.has_exact_double(112_233) == true
      assert SecureContainer.has_exact_double(123_444) == false
      assert SecureContainer.has_exact_double(111_122) == true
    end

    @tag day: 04, year: 2019
    test "input", %{input: input} do
      assert input |> SecureContainer.part_2() == 1148
    end
  end
end
