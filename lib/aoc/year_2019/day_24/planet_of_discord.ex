defmodule Aoc.Year2019.Day24.PlanetofDiscord do
  @moduledoc """
  ## --- Day 24: Planet of Discord ---

  You land on Eris, your last stop before reaching Santa. As soon as you do, your
  sensors start picking up strange life forms moving around: Eris is infested with
  bugs! With an over 24-hour roundtrip for messages between you and Earth, you'll
  have to deal with this problem on your own.

  Eris isn't a very large place; a scan of the entire area fits into a 5x5 grid
  (your puzzle input). The scan shows *bugs* (`#`) and *empty spaces* (`.`).

  Each *minute*, The bugs live and die based on the number of bugs in the *four
  adjacent tiles*:

  - A bug *dies* (becoming an empty space) unless there is *exactly one* bug adjacent to it.
  - An empty space *becomes infested* with a bug if *exactly one or two* bugs are adjacent to it.
  Otherwise, a bug or empty space remains the same. (Tiles on the edges of the
  grid have fewer than four adjacent tiles; the missing tiles count as empty
  space.) This process happens in every location *simultaneously*; that is, within
  the same minute, the number of adjacent bugs is counted for every tile first,
  and then the tiles are updated.

  Here are the first few minutes of an example scenario:

  `Initial state:
  ....#
  #..#.
  #..##
  ..#..
  #....

  After 1 minute:
  #..#.
  ####.
  ###.#
  ##.##
  .##..

  After 2 minutes:
  #####
  ....#
  ....#
  ...#.
  #.###

  After 3 minutes:
  #....
  ####.
  ...##
  #.##.
  .##.#

  After 4 minutes:
  ####.
  ....#
  ##..#
  .....
  ##...
  `To understand the nature of the bugs, watch for the first time a layout of bugs
  and empty spaces *matches any previous layout*. In the example above, the first
  layout to appear twice is:

  `.....
  .....
  .....
  #....
  .#...
  `To calculate the *biodiversity rating* for this layout, consider each tile
  left-to-right in the top row, then left-to-right in the second row, and so on.
  Each of these tiles is worth biodiversity points equal to *increasing powers of
  two*: 1, 2, 4, 8, 16, 32, and so on. Add up the biodiversity points for tiles
  with bugs; in this example, the 16th tile (`32768` points) and 22nd tile
  (`2097152` points) have bugs, a total biodiversity rating of `*2129920*`.

  *What is the biodiversity rating for the first layout that appears twice?*


  """

  use Bitwise

  @doc """

  """
  def part_1(input) do
    map = input |> parse

    previous = MapSet.new() |> MapSet.put(map)

    first_repeat(map, previous) |> print |> IO.puts()

    first_repeat(map, previous)
    |> biodiversity
  end

  def first_repeat(map, previous) do
    new_map = step(map)

    case MapSet.member?(previous, new_map) do
      true -> new_map
      false -> first_repeat(new_map, MapSet.put(previous, new_map))
    end
  end

  def step_level(levels) do
    previous_levels = levels
  end

  def biodiversity(map) do
    0..4
    |> Enum.reduce(0, fn y, acc -> biodiversity_row(map, y, acc) end)
  end

  def biodiversity_row(map, y, acc) do
    0..4
    |> Enum.reduce(acc, fn x, acc ->
      case Map.get(map, {x, y}, false) do
        true -> acc + (1 <<< (x + y * 5))
        false -> acc
      end
    end)
  end

  def step(map) do
    orig_map = map

    0..4
    |> Enum.reduce(map, fn y, map -> step_row(y, map, orig_map) end)
  end

  def step_row(y, map, orig_map) do
    0..4
    |> Enum.reduce(map, fn x, new_map ->
      adj = adjacent(orig_map, x, y)
      current = Map.get(orig_map, {x, y}, false)

      new_tile =
        case {current, adj} do
          {true, 1} -> true
          {true, _} -> false
          {false, 1} -> true
          {false, 2} -> true
          _ -> current
        end

      Map.put(new_map, {x, y}, new_tile)
    end)
  end

  def adjacent(map, x, y) do
    [
      Map.get(map, {x - 1, y}, false),
      Map.get(map, {x, y - 1}, false),
      Map.get(map, {x, y + 1}, false),
      Map.get(map, {x + 1, y}, false)
    ]
    |> Enum.filter(fn tile -> tile == true end)
    |> Enum.count()
  end

  @doc """

  """
  def part_2(input, minutes \\ 200) do
    map = input |> parse

    levels = %{0 => map}

    1..minutes
    |> Enum.reduce(levels, fn _, levels -> step2(levels) end)
    |> Enum.map(fn {level, map} ->
      map |> Map.values() |> Enum.filter(fn t -> t == true end) |> Enum.count()
    end)
    |> Enum.sum()
  end

  def step2(levels) do
    min_level = levels |> Map.keys() |> Enum.min()
    max_level = levels |> Map.keys() |> Enum.max()
    orig_levels = levels

    (min_level - 1)..(max_level + 1)
    |> Enum.reduce(levels, fn level, levels ->
      step_map2(levels, level, orig_levels)
    end)
  end

  def step_map2(levels, level, orig_levels) do
    new_level =
      0..4
      |> Enum.reduce(%{}, fn y, map -> step_row2(y, map, orig_levels, level) end)

    Map.put(levels, level, new_level)
  end

  def step_row2(y, map, orig_levels, level) do
    orig_map = Map.get(orig_levels, level, %{})

    0..4
    |> Enum.reduce(map, fn x, new_map ->
      adj = adjacent2(orig_levels, x, y, level)
      current = Map.get(orig_map, {x, y}, false)

      new_tile =
        case {{x, y}, current, adj} do
          {{2, 2}, _, _} -> false
          {_, true, 1} -> true
          {_, true, _} -> false
          {_, false, 1} -> true
          {_, false, 2} -> true
          _ -> current
        end

      Map.put(new_map, {x, y}, new_tile)
    end)
  end

  def adjacent2(levels, x, y, level) do
    map = Map.get(levels, level, %{})
    previous_level = Map.get(levels, level - 1, %{})
    next_level = Map.get(levels, level + 1, %{})

    map =
      0..4
      |> Enum.reduce(map, fn i, map ->
        map
        |> Map.put({i, -1}, Map.get(previous_level, {2, 1}, false))
        |> Map.put({i, 5}, Map.get(previous_level, {2, 3}, false))
        |> Map.put({-1, i}, Map.get(previous_level, {1, 2}, false))
        |> Map.put({5, i}, Map.get(previous_level, {3, 2}, false))
      end)

    adjacent = [
      Map.get(map, {x - 1, y}, false),
      Map.get(map, {x, y - 1}, false),
      Map.get(map, {x, y + 1}, false),
      Map.get(map, {x + 1, y}, false)
    ]

    extra =
      case {x, y} do
        {2, 1} -> 0..4 |> Enum.map(fn x -> Map.get(next_level, {x, 0}) end)
        {2, 3} -> 0..4 |> Enum.map(fn x -> Map.get(next_level, {x, 4}) end)
        {1, 2} -> 0..4 |> Enum.map(fn y -> Map.get(next_level, {0, y}) end)
        {3, 2} -> 0..4 |> Enum.map(fn y -> Map.get(next_level, {4, y}) end)
        _ -> []
      end

    adjacent = adjacent ++ extra

    count =
      adjacent
      |> Enum.filter(fn tile -> tile == true end)
      |> Enum.count()

    adjacent
    |> Enum.filter(fn tile -> tile == true end)
    |> Enum.count()
  end

  def parse(input) do
    input |> String.split("\n") |> Enum.with_index() |> Enum.reduce(%{}, &parse_row/2)
  end

  def parse_row({row, y}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn
      {"#", x}, map -> Map.put(map, {x, y}, true)
      {".", _x}, map -> map
      {"?", _x}, map -> map
    end)
  end

  def print(map) do
    0..4
    |> Enum.map(fn y ->
      Enum.map(0..4, fn x ->
        case {x, y} do
          {x, y} -> Map.get(map, {x, y}, false) |> char
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def char(true), do: "#"
  def char(false), do: "."
end
