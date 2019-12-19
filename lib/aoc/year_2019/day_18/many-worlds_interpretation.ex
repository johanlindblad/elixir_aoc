defmodule Aoc.Year2019.Day18.ManyWorldsInterpretation do
  @moduledoc """
  ## --- Day 18: Many-Worlds Interpretation ---

  As you approach Neptune, a planetary security system detects you and activates a
  giant tractor beam on Triton! You have no choice but to land.

  A scan of the local area reveals only one interesting feature: a massive
  underground vault. You generate a map of the tunnels (your puzzle input). The
  tunnels are too narrow to move diagonally.

  Only one *entrance* (marked `@`) is present among the *open passages* (marked
  `.`) and *stone walls* (`#`), but you also detect an assortment of *keys* (shown
  as lowercase letters) and *doors* (shown as uppercase letters). Keys of a given
  letter open the door of the same letter: `a` opens `A`, `b` opens `B`, and so
  on. You aren't sure which key you need to disable the tractor beam, so you'll
  need to *collect all of them*.

  For example, suppose you have the following map:

  `#########
  #b.A.@.a#
  #########
  `Starting from the entrance (`@`), you can only access a large door (`A`) and a
  key (`a`). Moving toward the door doesn't help you, but you can move `2` steps
  to collect the key, unlocking `A` in the process:

  `#########
  #b.....@#
  #########
  `Then, you can move `6` steps to collect the only other key, `b`:

  `#########
  #@......#
  #########
  `So, collecting every key took a total of `*8*` steps.

  Here is a larger example:

  `########################
  #f.D.E.e.C.b.A.@.a.B.c.#
  ######################.#
  #d.....................#
  ########################
  `The only reasonable move is to take key `a` and unlock door `A`:

  `########################
  #f.D.E.e.C.b.....@.B.c.#
  ######################.#
  #d.....................#
  ########################
  `Then, do the same with key `b`:

  `########################
  #f.D.E.e.C.@.........c.#
  ######################.#
  #d.....................#
  ########################
  `...and the same with key `c`:

  `########################
  #f.D.E.e.............@.#
  ######################.#
  #d.....................#
  ########################
  `Now, you have a choice between keys `d` and `e`. While key `e` is closer,
  collecting it now would be slower in the long run than collecting key `d` first,
  so that's the best choice:

  `########################
  #f...E.e...............#
  ######################.#
  #@.....................#
  ########################
  `Finally, collect key `e` to unlock door `E`, then collect key `f`, taking a
  grand total of `*86*` steps.

  Here are a few more examples:

  - `########################
  #...............b.C.D.f#
  #.######################
  #.....@.a.B.c.d.A.e.F.g#
  ########################
  `Shortest path is `132` steps: `b`, `a`, `c`, `d`, `f`, `e`, `g`


  - `#################
  #i.G..c...e..H.p#
  ########.########
  #j.A..b...f..D.o#
  ########@########
  #k.E..a...g..B.n#
  ########.########
  #l.F..d...h..C.m#
  #################
  `Shortest paths are `136` steps;one is: `a`, `f`, `b`, `j`, `g`, `n`, `h`, `d`,
  `l`, `o`, `e`, `p`, `c`, `i`, `k`, `m`


  - `########################
  #@..............ac.GI.b#
  ###d#e#f################
  ###A#B#C################
  ###g#h#i################
  ########################
  `Shortest paths are `81` steps; one is: `a`, `c`, `f`, `i`, `d`, `g`, `b`, `e`,
  `h`


  *How many steps is the shortest path that collects all of the keys?*


  """

  @doc """

  """
  def part_1(input) do
    {map, start, keys} = input |> parse

    initial = %{{MapSet.new(), start} => 0}

    run(map, initial, keys, MapSet.size(keys))
  end

  def run(_map, visited, _keys, 0) do
    visited
    |> Map.values()
    |> Enum.min()
  end

  def run(map, visited, keys, keys_left) do
    # IO.inspect(Map.keys(visited) |> Enum.at(0))

    new_visited =
      Enum.reduce(visited, %{}, fn {{keys, pos}, steps}, acc ->
        reachable_letters([{pos, steps}], map, MapSet.new(keys))
        |> Enum.reduce(acc, fn {letter, new_steps, end_pos}, acc ->
          new_keys = MapSet.put(keys, letter)

          case Map.get(acc, {new_keys, end_pos}) do
            other_steps when other_steps < new_steps ->
              acc

            _ ->
              Map.put(acc, {new_keys, end_pos}, new_steps)
          end
        end)
      end)

    run(map, new_visited, keys, keys_left - 1)
  end

  @directions [{0, -1}, {0, 1}, {1, 0}, {-1, 0}]
  def reachable_letters(queue, map, keys, visited \\ MapSet.new(), acc \\ [])
  def reachable_letters([], _, _keys, _visited, acc), do: acc

  def reachable_letters([{{x, y}, steps} | tail], map, keys, visited, acc) do
    visited = MapSet.put(visited, {x, y})
    # IO.inspect("visited")
    # IO.inspect(visited)

    {acc, visited, queue} =
      @directions
      |> Enum.reduce({acc, visited, tail}, fn direction, {acc, visited, queue} ->
        {dx, dy} = direction
        {nx, ny} = {x + dx, y + dy}
        # IO.inspect("CHECKING #{nx} #{ny} #{Map.get(map, {nx, ny})}")

        case MapSet.member?(visited, {nx, ny}) do
          true ->
            # IO.inspect("VISITED #{nx} #{ny}")
            {acc, visited, queue}

          false ->
            case Map.get(map, {nx, ny}) do
              nil ->
                {acc, visited, queue}

              "." ->
                queue = queue ++ [{{nx, ny}, steps + 1}]
                visited = MapSet.put(visited, {x, y})
                {acc, visited, queue}

              letter = <<code::utf8>> when code in ?a..?z ->
                # IO.inspect("FOUND #{<<letter>>}")

                {queue, visited, acc} =
                  case MapSet.member?(keys, letter) do
                    true ->
                      queue = queue ++ [{{nx, ny}, steps + 1}]
                      visited = MapSet.put(visited, {nx, ny})
                      {queue, visited, acc}

                    false ->
                      acc = [{letter, steps + 1, {nx, ny}} | acc]
                      # queue = queue ++ [{{nx, ny}, steps + 1}]
                      {queue, visited, acc}
                  end

                {acc, visited, queue}

              letter ->
                case MapSet.member?(keys, String.downcase(letter)) do
                  true ->
                    queue = queue ++ [{{nx, ny}, steps + 1}]
                    visited = MapSet.put(visited, {nx, ny})
                    {acc, visited, queue}

                  false ->
                    {acc, visited, queue}
                end
            end
        end
      end)

    reachable_letters(queue, map, keys, visited, acc)
  end

  @doc """

  """
  def part_2(input) do
    {map, start, keys} = input |> parse

    {x, y} = start

    map =
      Map.delete(map, start)
      |> Map.delete({x + 1, y})
      |> Map.delete({x - 1, y})
      |> Map.delete({x, y - 1})
      |> Map.delete({x, y + 1})

    robots = MapSet.new([{x + 1, y - 1}, {x + 1, y + 1}, {x - 1, y - 1}, {x - 1, y + 1}])

    initial = %{{MapSet.new(), robots} => 0}

    run2(map, initial, keys, MapSet.size(keys))
  end

  def run2(_map, visited, _keys, 0) do
    visited
    |> Map.values()
    |> Enum.min()
  end

  def run2(map, visited, keys, keys_left) do
    new_visited =
      Enum.reduce(visited, %{}, fn {{keys, robots}, steps}, acc ->
        Enum.reduce(robots, acc, fn robot, acc ->
          reachable_letters([{robot, steps}], map, MapSet.new(keys))
          |> Enum.reduce(acc, fn {letter, new_steps, end_pos}, acc ->
            new_keys = MapSet.put(keys, letter)

            new_robots = MapSet.delete(robots, robot) |> MapSet.put(end_pos)

            case Map.get(acc, {new_keys, new_robots}) do
              other_steps when other_steps < new_steps ->
                acc

              _ ->
                Map.put(acc, {new_keys, new_robots}, new_steps)
            end
          end)
        end)
      end)

    run2(map, new_visited, keys, keys_left - 1)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil, MapSet.new()}, &parse_row/2)
  end

  def parse_row({row, y}, {map, start, keys}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({map, start, keys}, fn {char, x}, {map, start, keys} ->
      case char do
        "#" ->
          {map, start, keys}

        "@" ->
          map = Map.put(map, {x, y}, ".")
          {map, {x, y}, keys}

        <<letter::utf8>> when letter in ?a..?z ->
          map = Map.put(map, {x, y}, <<letter>>)
          keys = MapSet.put(keys, <<letter>>)
          {map, start, keys}

        _ ->
          map = Map.put(map, {x, y}, char)
          {map, start, keys}
      end
    end)
  end
end
