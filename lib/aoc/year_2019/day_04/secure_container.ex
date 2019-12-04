defmodule Aoc.Year2019.Day04.SecureContainer do
  @moduledoc """
  ## --- Day 4: Secure Container ---

  You arrive at the Venus fuel depot only to discover it's protected by a
  password. The Elves had written the password on a sticky note, but someone threw
  it out.

  However, they do remember a few key facts about the password:

  - It is a six-digit number.
  - The value is within the range given in your puzzle input.
  - Two adjacent digits are the same (like `22` in `1*22*345`).
  - Going from left to right, the digits *never decrease*; they only ever increase or stay the same (like `111123` or `135679`).
  Other than the range rule, the following are true:

  - `111111` meets these criteria (double `11`, never decreases).
  - `2234*50*` does not meet these criteria (decreasing pair of digits `50`).
  - `123789` does not meet these criteria (no double).
  *How many different passwords* within the range given in your puzzle input meet
  these crit
  ## --- Part Two ---

  An Elf just remembered one more important detail: the two adjacent matching
  digits *are not part of a larger group of matching digits*.

  Given this additional criterion, but still ignoring the range rule, the
  following are now true:

  - `112233` meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
  - `123*444*` no longer meets the criteria (the repeated `44` is part of a larger group of `444`).
  - `111122` meets the criteria (even though `1` is repeated more than twice, it still contains a double `22`).
  *How many different passwords* within the range given in your puzzle input meet
  all of the criteria?

  eria?


  """

  @doc """

  """
  def part_1(input) do
    [from, to] = input |> String.trim() |> String.split("-") |> Enum.map(&String.to_integer/1)

    from..to
    |> Enum.count(fn i -> has_double(i) && never_decreases(i) end)
  end

  def all_matching(from, to, num_matching \\ 0)
  def all_matching(from, from, num_matching), do: num_matching

  def all_matching(from, to, num_matching) do
    case has_double(from) && never_decreases(from) do
      true -> all_matching(from + 1, to, num_matching + 1)
      false -> all_matching(from + 1, to, num_matching)
    end
  end

  defp has_double(from) when is_integer(from),
    do: has_double(from |> Integer.digits())

  defp has_double([a, a | _other]), do: true
  defp has_double([_a | other]), do: has_double(other)
  defp has_double([]), do: false

  defp never_decreases(from) when is_integer(from),
    do: never_decreases(from |> Integer.digits())

  defp never_decreases([a, b | _other]) when a > b, do: false
  defp never_decreases([_a, b | other]), do: never_decreases([b | other])
  defp never_decreases([_a]), do: true

  @doc """

  """
  def part_2(input) do
    [from, to] = input |> String.trim() |> String.split("-") |> Enum.map(&String.to_integer/1)

    from..to
    |> Enum.count(fn i -> has_exact_double(i) && never_decreases(i) end)
  end

  def has_exact_double(from) when is_integer(from),
    do: has_exact_double(from |> Integer.digits())

  def has_exact_double([d | rest]), do: has_exact_double(rest, {d, 1})
  def has_exact_double([], {_d, count}), do: count == 2

  def has_exact_double([d | rest], {d, count}) do
    has_exact_double(rest, {d, count + 1})
  end

  def has_exact_double([_non_d | _rest], {_d, 2}), do: true

  def has_exact_double([non_d | rest], {_d, _not_2}) do
    has_exact_double(rest, {non_d, 1})
  end
end
