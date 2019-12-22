defmodule Aoc.Year2019.Day22.SlamShuffle do
  @moduledoc """
  ## --- Day 22: Slam Shuffle ---

  There isn't much to do while you wait for the droids to repair your ship. At
  least you're drifting in the right direction. You decide to practice a new card
  shuffle you've been working on.

  Digging through the ship's storage, you find a deck of *space cards*! Just like
  any deck of space cards, there are 10007 cards in the deck numbered `0` through
  `10006`. The deck must be new - they're still in *factory order*, with `0` on
  the top, then `1`, then `2`, and so on, all the way through to `10006` on the
  bottom.

  You've been practicing three different *techniques* that you use while
  shuffling. Suppose you have a deck of only 10 cards (numbered `0` through `9`):

  *To `deal into new stack`*, create a new stack of cards by dealing the top card
  of the deck onto the top of the new stack repeatedly until you run out of cards:

  `Top          Bottom
  0 1 2 3 4 5 6 7 8 9   Your deck
                        New stack

    1 2 3 4 5 6 7 8 9   Your deck
                    0   New stack

      2 3 4 5 6 7 8 9   Your deck
                  1 0   New stack

        3 4 5 6 7 8 9   Your deck
                2 1 0   New stack

  Several steps later...

                    9   Your deck
    8 7 6 5 4 3 2 1 0   New stack

                        Your deck
  9 8 7 6 5 4 3 2 1 0   New stack
  `Finally, pick up the new stack you've just created and use it as the deck for
  the next technique.

  *To `cut N` cards*, take the top `N` cards off the top of the deck and move them
  as a single unit to the bottom of the deck, retaining their order. For example,
  to `cut 3`:

  `Top          Bottom
  0 1 2 3 4 5 6 7 8 9   Your deck

        3 4 5 6 7 8 9   Your deck
  0 1 2                 Cut cards

  3 4 5 6 7 8 9         Your deck
                0 1 2   Cut cards

  3 4 5 6 7 8 9 0 1 2   Your deck
  `You've also been getting pretty good at a version of this technique where `N` is
  negative! In that case, cut (the absolute value of) `N` cards from the bottom of
  the deck onto the top. For example, to `cut -4`:

  `Top          Bottom
  0 1 2 3 4 5 6 7 8 9   Your deck

  0 1 2 3 4 5           Your deck
              6 7 8 9   Cut cards

          0 1 2 3 4 5   Your deck
  6 7 8 9               Cut cards

  6 7 8 9 0 1 2 3 4 5   Your deck
  `*To `deal with increment N`*, start by clearing enough space on your table to
  lay out all of the cards individually in a long line. Deal the top card into the
  leftmost position. Then, move `N` positions to the right and deal the next card
  there. If you would move into a position past the end of the space on your
  table, wrap around and keep counting from the leftmost card again. Continue this
  process until you run out of cards.

  For example, to `deal with increment 3`:

  `
  0 1 2 3 4 5 6 7 8 9   Your deck
  . . . . . . . . . .   Space on table
  ^                     Current position

  Deal the top card to the current position:

    1 2 3 4 5 6 7 8 9   Your deck
  0 . . . . . . . . .   Space on table
  ^                     Current position

  Move the current position right 3:

    1 2 3 4 5 6 7 8 9   Your deck
  0 . . . . . . . . .   Space on table
        ^               Current position

  Deal the top card:

      2 3 4 5 6 7 8 9   Your deck
  0 . . 1 . . . . . .   Space on table
        ^               Current position

  Move right 3 and deal:

        3 4 5 6 7 8 9   Your deck
  0 . . 1 . . 2 . . .   Space on table
              ^         Current position

  Move right 3 and deal:

          4 5 6 7 8 9   Your deck
  0 . . 1 . . 2 . . 3   Space on table
                    ^   Current position

  Move right 3, wrapping around, and deal:

            5 6 7 8 9   Your deck
  0 . 4 1 . . 2 . . 3   Space on table
      ^                 Current position

  And so on:

  0 7 4 1 8 5 2 9 6 3   Space on table
  `Positions on the table which already contain cards are still counted; they're
  not skipped. Of course, this technique is carefully designed so it will never
  put two cards in the same position or leave a position empty.

  Finally, collect the cards on the table so that the leftmost card ends up at the
  top of your deck, the card to its right ends up just below the top card, and so
  on, until the rightmost card ends up at the bottom of the deck.

  The complete shuffle process (your puzzle input) consists of applying many of
  these techniques. Here are some examples that combine techniques; they all start
  with a *factory order* deck of 10 cards:

  `deal with increment 7
  deal into new stack
  deal into new stack
  Result: 0 3 6 9 2 5 8 1 4 7
  ``cut 6
  deal with increment 7
  deal into new stack
  Result: 3 0 7 4 1 8 5 2 9 6
  ``deal with increment 7
  deal with increment 9
  cut -2
  Result: 6 3 0 7 4 1 8 5 2 9
  ``deal into new stack
  cut -2
  deal with increment 7
  cut 8
  cut -4
  deal with increment 7
  cut 3
  deal with increment 9
  deal with increment 3
  cut -1
  Result: 9 2 5 8 1 4 7 0 3 6
  `Positions within the deck count from `0` at the top, then `1` for the card
  immediately below the top card, and so on to the bottom. (That is, cards start
  in the position matching their number.)

  After shuffling your *factory order* deck of 10007 cards, *what is the position
  of card `2019`?*


  """

  @doc """

  """
  def part_1(input, length \\ 10007, pos_of \\ 2019) do
    operations = input |> String.split("\n")
    {offset, increment, ^length} = Enum.reduce(operations, {0, 1, length}, &technique_math/2)

    numbers = Stream.iterate(offset, fn n -> Integer.mod(n + increment, length) end)

    numbers |> Enum.find_index(fn n -> n == pos_of end)
  end

  def run(input, n) do
    operations = input |> String.split("\n")
    deck = deck(n)

    Enum.reduce(operations, deck, &technique/2)
  end

  def technique("cut " <> rest, deck), do: cut(deck, String.to_integer(rest))

  def technique("deal into new stack", deck), do: deal(deck)

  def technique("deal with increment " <> rest, deck), do: deal_inc(deck, String.to_integer(rest))

  def deck(n), do: 0..(n - 1) |> Enum.to_list()
  def deal(deck), do: deck |> Enum.reverse()

  def cut(deck, n) when n > 0 do
    {top, bottom} = Enum.split(deck, n)
    bottom ++ top
  end

  def cut(deck, n) when n < 0, do: cut(deck, length(deck) + n)

  def deal_inc(deck, inc) do
    length = length(deck)

    map =
      deck
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {elem, i}, map ->
        i = (i * inc) |> rem(length)
        Map.put(map, i, elem)
      end)

    0..(length - 1) |> Enum.map(&map[&1])
  end

  @doc """

  """
  # Translated from https://www.reddit.com/r/adventofcode/comments/ee0rqi/2019_day_22_solutions/fbnkaju/
  def part_2(input, length \\ 119_315_717_514_047, times \\ 101_741_582_076_661) do
    operations = input |> String.split("\n")

    {offset, increment, length} = {0, 1, length}

    {offset, increment, length} =
      Enum.reduce(operations, {offset, increment, length}, &technique_math/2)

    increment_multiple = increment
    offset_add_increment_times = offset

    final_increment = pow(increment_multiple, times, length)

    final_offset =
      offset_add_increment_times * (1 - pow(increment_multiple, times, length)) *
        inverse(1 - increment_multiple, length)

    numbers = Stream.iterate(final_offset, fn n -> Integer.mod(n + final_increment, length) end)

    numbers |> Enum.at(2020)
  end

  def technique_math("cut " <> rest, {offset, increment, length}) do
    n = String.to_integer(rest)
    offset = Integer.mod(offset + increment * n, length)
    {offset, increment, length}
  end

  def technique_math("deal into new stack", {offset, increment, length}) do
    increment = increment * -1
    offset = Integer.mod(offset + increment, length)
    {offset, increment, length}
  end

  def technique_math("deal with increment " <> rest, {offset, increment, length}) do
    n = String.to_integer(rest)
    increment = Integer.mod(increment * inverse(n, length), length)

    {offset, increment, length}
  end

  # https://en.wikipedia.org/wiki/Modular_exponentiation#Pseudocode
  def pow(base, exponent, modulus) do
    result = 1

    base = Integer.mod(base, modulus)

    {_base, result} =
      Integer.digits(exponent, 2)
      |> Enum.reverse()
      |> Enum.reduce({base, result}, fn
        0, {base, result} ->
          base = Integer.mod(base * base, modulus)
          {base, result}

        1, {base, result} ->
          result = Integer.mod(result * base, modulus)
          base = Integer.mod(base * base, modulus)
          {base, result}
      end)

    result
  end

  # https://rosettacode.org/wiki/Modular_inverse#Elixir
  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end

  def inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise("The maths are broken!")
    rem(x + et, et)
  end
end
