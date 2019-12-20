defmodule Aoc.Year2019.Day20.DonutMaze do
  @moduledoc """
  ## --- Day 20: Donut Maze ---

  You notice a strange pattern on the surface of Pluto and land nearby to get a
  closer look. Upon closer inspection, you realize you've come across one of the
  famous space-warping mazes of the long-lost Pluto civilization!

  Because there isn't much space on Pluto, the civilization that used to live here
  thrived by inventing a method for folding spacetime. Although the technology is
  no longer understood, mazes like this one provide a small glimpse into the daily
  life of an ancient Pluto citizen.

  This maze is shaped like a donut. Portals along the inner and outer edge of the
  donut can instantly teleport you from one side to the other. For example:

  `         A
           A
    #######.#########
    #######.........#
    #######.#######.#
    #######.#######.#
    #######.#######.#
    #####  B    ###.#
  BC...##  C    ###.#
    ##.##       ###.#
    ##...DE  F  ###.#
    #####    G  ###.#
    #########.#####.#
  DE..#######...###.#
    #.#########.###.#
  FG..#########.....#
    ###########.#####
               Z
               Z
  `This map of the maze shows solid walls (`#`) and open passages (`.`). Every maze
  on Pluto has a start (the open tile next to `AA`) and an end (the open tile next
  to `ZZ`). Mazes on Pluto also have portals; this maze has three pairs of
  portals: `BC`, `DE`, and `FG`. When on an open tile next to one of these labels,
  a single step can take you to the other tile with the same label. (You can only
  walk on `.` tiles; labels and empty space are not traversable.)

  One path through the maze doesn't require any portals. Starting at `AA`, you
  could go down 1, right 8, down 12, left 4, and down 1 to reach `ZZ`, a total of
  26 steps.

  However, there is a shorter path: You could walk from `AA` to the inner `BC`
  portal (4 steps), warp to the outer `BC` portal (1 step), walk to the inner `DE`
  (6 steps), warp to the outer `DE` (1 step), walk to the outer `FG` (4 steps),
  warp to the inner `FG` (1 step), and finally walk to `ZZ` (6 steps). In total,
  this is only *23* steps.

  Here is a larger example:

  `                   A
                     A
    #################.#############
    #.#...#...................#.#.#
    #.#.#.###.###.###.#########.#.#
    #.#.#.......#...#.....#.#.#...#
    #.#########.###.#####.#.#.###.#
    #.............#.#.....#.......#
    ###.###########.###.#####.#.#.#
    #.....#        A   C    #.#.#.#
    #######        S   P    #####.#
    #.#...#                 #......VT
    #.#.#.#                 #.#####
    #...#.#               YN....#.#
    #.###.#                 #####.#
  DI....#.#                 #.....#
    #####.#                 #.###.#
  ZZ......#               QG....#..AS
    ###.###                 #######
  JO..#.#.#                 #.....#
    #.#.#.#                 ###.#.#
    #...#..DI             BU....#..LF
    #####.#                 #.#####
  YN......#               VT..#....QG
    #.###.#                 #.###.#
    #.#...#                 #.....#
    ###.###    J L     J    #.#.###
    #.....#    O F     P    #.#...#
    #.###.#####.#.#####.#####.###.#
    #...#.#.#...#.....#.....#.#...#
    #.#####.###.###.#.#.#########.#
    #...#.#.....#...#.#.#.#.....#.#
    #.###.#####.###.###.#.#.#######
    #.#.........#...#.............#
    #########.###.###.#############
             B   J   C
             U   P   P
  `Here, `AA` has no direct path to `ZZ`, but it does connect to `AS` and `CP`. By
  passing through `AS`, `QG`, `BU`, and `JO`, you can reach `ZZ` in *58* steps.

  In your maze, *how many steps does it take to get from the open tile marked `AA`
  to the open tile marked `ZZ`?*


  """

  @doc """

  """
  def part_1(input) do
    map = input |> parse
    {map, start_at, end_at} = handle_letters(map)

    {start_pos, _delta} = start_at
    {end_pos, _delta} = end_at

    queue = [{start_pos, 0}]

    shortest(queue, map, end_pos, MapSet.new())
  end

  @dirs [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
  def shortest([{end_pos, steps} | _rest], _, end_pos, _visited), do: steps

  def shortest([{pos, steps} | rest], map, end_pos, visited) do
    visited = MapSet.put(visited, pos)
    {x, y} = pos

    queue =
      @dirs
      |> Enum.reject(fn {dx, dy} -> MapSet.member?(visited, {x + dx, y + dy}) end)
      |> Enum.reduce(rest, fn {dx, dy}, queue ->
        case Map.get(map, {x + dx, y + dy}, " ") do
          "." ->
            queue ++ [{{x + dx, y + dy}, steps + 1}]

          {:portal, to, _, _} ->
            # 2 steps may not be compatible with BFS
            queue ++ [{to, steps + 2}]

          _other ->
            queue
        end
      end)

    shortest(queue, map, end_pos, visited)
  end

  def handle_letters(map) do
    letter_pairs = letter_pairs(map)

    {_map, _start_at, _end_at} =
      letter_pairs
      |> Enum.reduce({map, nil, nil}, fn
        {{"A", "A"}, [{{x, y}, {dx, dy}, _, _}]}, {map, _, end_at} ->
          start_at = inner_pos({x, y}, {dx, dy}, map)
          {map, start_at, end_at}

        {{"Z", "Z"}, [{{x, y}, {dx, dy}, _, _}]}, {map, start_at, _} ->
          end_at = inner_pos({x, y}, {dx, dy}, map)
          {map, start_at, end_at}

        {{l1, l2}, [{pos1, d1, _, _}, {pos2, d2, _, _}]}, {map, start_at, end_at} ->
          {inner1, _} = inner_pos(pos1, d1, map)
          {inner2, _} = inner_pos(pos2, d2, map)
          outer1 = outer(map, inner1)
          outer2 = outer(map, inner2)

          map = Map.put(map, inner1, {:portal, inner2, l1 <> l2, outer1})
          map = Map.put(map, inner2, {:portal, inner1, l1 <> l2, outer2})
          {map, start_at, end_at}
      end)
  end

  def inner_pos({x, y}, {dx, dy}, map) do
    cond do
      Map.get(map, {x - dx, y - dy}, " ") == "." ->
        {{x - dx, y - dy}, {-dx, -dy}}

      Map.get(map, {x + dx + dx, y + dy + dy}, " ") == "." ->
        {{x + dx + dx, y + dy + dy}, {dx, dy}}
    end
  end

  @doc """

  """
  def part_2(input) do
    map = input |> parse
    {map, start_at, end_at} = handle_letters(map)

    {start_pos, _delta} = start_at
    {end_pos, _delta} = end_at

    queue = [{start_pos, 0, 0}]

    _portals =
      Enum.filter(map, fn
        {_pos, {:portal, _to, _l, _}} -> true
        _ -> false
      end)

    # distances = distances(portals, map)

    shortest2(queue, map, end_pos, MapSet.new())
  end

  def distances([portal | _rest], map, _acc \\ %{}) do
    {{_x, _y}, _, pair} = portal
    inner_bfs(portal, map, pair)
  end

  def inner_bfs(queue, map, pair, visited \\ MapSet.new(), distances \\ %{})

  def inner_bfs([], _map, _pair, _visited, distances), do: distances

  def inner_bfs([{pos, steps} | rest], map, pair, visited, distances) do
    visited = MapSet.put(visited, pos)
    {x, y} = pos

    {_queue, _distances} =
      @dirs
      |> Enum.reject(fn {dx, dy} -> MapSet.member?(visited, {x + dx, y + dy}) end)
      |> Enum.reduce(rest, fn {dx, dy}, queue ->
        case Map.get(map, {x + dx, y + dy}, " ") do
          "." ->
            {queue ++ [{{x + dx, y + dy}, steps + 1}], distances}

          {:portal, _to, ^pair, _outer} ->
            {queue, distances}

          {:portal, _to, other_pair, _outer} ->
            # 2 steps may not be compatible with BFS
            _map =
              Map.put(distances, {pair, other_pair}, steps)
              |> Map.put({other_pair, pair}, steps)

          _other ->
            queue
        end
      end)
  end

  @dirs [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
  def shortest2([{end_pos, steps, 0} | _rest], _, end_pos, _visited), do: steps

  def shortest2([{pos, steps, level} | rest], map, end_pos, visited) do
    visited = MapSet.put(visited, {pos, level})
    {x, y} = pos

    queue =
      @dirs
      |> Enum.reject(fn {dx, dy} -> MapSet.member?(visited, {{x + dx, y + dy}, level}) end)
      |> Enum.reduce(rest, fn {dx, dy}, queue ->
        case Map.get(map, {x + dx, y + dy}, " ") do
          "." ->
            queue ++ [{{x + dx, y + dy}, steps + 1, level}]

          {:portal, to, _pair, outer} ->
            # 2 steps may not be compatible with BFS
            case {outer, level} do
              {true, 0} -> queue
              {true, level} -> queue ++ [{to, steps + 2, level - 1}]
              {false, level} -> queue ++ [{to, steps + 2, level + 1}]
            end

          _other ->
            queue
        end
      end)

    queue = Enum.sort_by(queue, fn {_, _, level} -> level end)
    shortest2(queue, map, end_pos, visited)
  end

  def parse(input, y \\ 0, x \\ 0, map \\ %{})

  def parse(<<>>, _, _, map), do: map

  def parse(<<tile::utf8>> <> rest, y, x, map) do
    {map, x, y} =
      case <<tile>> do
        " " -> {map, x + 1, y}
        "#" -> {map, x + 1, y}
        "." -> {Map.put(map, {x, y}, "."), x + 1, y}
        "\n" -> {map, 0, y + 1}
        letter -> {Map.put(map, {x, y}, letter), x + 1, y}
      end

    parse(rest, y, x, map)
  end

  @other_tile [{0, 1}, {1, 0}]
  def letter_pairs(map) do
    _portals =
      for {{x, y}, letter} <- Map.to_list(map),
          <<code>> = letter,
          code in ?A..?Z do
        {{x, y}, letter}
      end
      |> Enum.map(fn {{x, y}, letter} ->
        other =
          @other_tile
          |> Enum.find(fn {dx, dy} ->
            <<code>> = Map.get(map, {x + dx, y + dy}, " ")
            # IO.inspect({x, y, letter, <<code>>})
            code in ?A..?Z
          end)

        case other do
          {dx, dy} ->
            {{x, y}, {dx, dy}, letter, Map.get(map, {x + dx, y + dy})}

          nil ->
            nil
        end
      end)
      |> Enum.filter(fn item -> item != nil end)
      |> Enum.group_by(fn {_pos, _delta, letter1, letter2} -> {letter1, letter2} end)
  end

  def width(map), do: Map.keys(map) |> Enum.max_by(fn {x, _y} -> x end) |> elem(0)
  def height(map), do: Map.keys(map) |> Enum.max_by(fn {_x, y} -> y end) |> elem(1)
  def outer(map, {x, y}), do: x < 3 || y < 3 || x + 3 > width(map) || y + 3 > height(map)
end
