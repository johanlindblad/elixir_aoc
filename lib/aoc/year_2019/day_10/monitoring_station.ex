defmodule Aoc.Year2019.Day10.MonitoringStation do
  @moduledoc """
  ## --- Day 10: Monitoring Station ---

  You fly into the asteroid belt and reach the Ceres monitoring station. The Elves
  here have an emergency: they're having trouble tracking all of the asteroids and
  can't be sure they're safe.

  The Elves would like to build a new monitoring station in a nearby area of
  space; they hand you a map of all of the asteroids in that region (your puzzle
  input).

  The map indicates whether each position is empty (`.`) or contains an asteroid
  (`#`). The asteroids are much smaller than they appear on the map, and every
  asteroid is exactly in the center of its marked position. The asteroids can be
  described with `X,Y` coordinates where `X` is the distance from the left edge
  and `Y` is the distance from the top edge (so the top-left corner is `0,0` and
  the position immediately to its right is `1,0`).

  Your job is to figure out which asteroid would be the best place to build a *new
  monitoring station*. A monitoring station can *detect* any asteroid to which it
  has *direct line of sight* - that is, there cannot be another asteroid *exactly*
  between them. This line of sight can be at any angle, not just lines aligned to
  the grid or diagonally. The *best* location is the asteroid that can *detect*
  the largest number of other asteroids.

  For example, consider the following map:

  `.#..#
  .....
  #####
  ....#
  ...*#*#
  `The best location for a new monitoring station on this map is the highlighted
  asteroid at `3,4` because it can detect `8` asteroids, more than any other
  location. (The only asteroid it cannot detect is the one at `1,0`; its view of
  this asteroid is blocked by the asteroid at `2,2`.) All other asteroids are
  worse locations; they can detect `7` or fewer other asteroids. Here is the
  number of other asteroids a monitoring station on each asteroid could detect:

  `.7..7
  .....
  67775
  ....7
  ...87
  `Here is an asteroid (`#`) and some examples of the ways its line of sight might
  be blocked. If there were another asteroid at the location of a capital letter,
  the locations marked with the corresponding lowercase letter would be blocked
  and could not be detected:

  `#.........
  ...A......
  ...B..a...
  .EDCG....a
  ..F.c.b...
  .....c....
  ..efd.c.gb
  .......c..
  ....f...c.
  ...e..d..c
  `Here are some larger examples:

  - Best is `5,8` with `33` other asteroids detected:

  `......#.#.
  #..#.#....
  ..#######.
  .#.#.###..
  .#..#.....
  ..#....#.#
  #..#....#.
  .##.#..###
  ##...*#*..#.
  .#....####
  `
  - Best is `1,2` with `35` other asteroids detected:

  `#.#...#.#.
  .###....#.
  .*#*....#...
  ##.#.#.#.#
  ....#.#.#.
  .##..###.#
  ..#...##..
  ..##....##
  ......#...
  .####.###.
  `
  - Best is `6,3` with `41` other asteroids detected:

  `.#..#..###
  ####.###.#
  ....###.#.
  ..###.*#*#.#
  ##.##.#.#.
  ....###..#
  ..#.#..#.#
  #..#.#.###
  .##...##.#
  .....#.#..
  `
  - Best is `11,13` with `210` other asteroids detected:

  `.#..##.###...#######
  ##.############..##.
  .#.######.########.#
  .###.#######.####.#.
  #####.##.#.##.###.##
  ..#####..#.#########
  ####################
  #.####....###.#.#.##
  ##.#################
  #####.##.###..####..
  ..######..##.#######
  ####.##.####...##..#
  .#####..#.######.###
  ##...#.####*#*#####...
  #.##########.#######
  .####.#.###.###.#.##
  ....##.##.###..#####
  .#.#.###########.###
  #.#.#.#####.####.###
  ###.##.####.##.#..##
  `
  Find the best location for a new monitoring station. *How many other asteroids
  can be detected from that location?*


  """

  @doc """

  """
  def part_1(input) do
    asteroids = input |> parse

    max = asteroids |> Enum.max_by(&asteroids_detected(&1, asteroids))
    max |> asteroids_detected(asteroids)
  end

  def asteroids_detected({x, y}, asteroids) do
    asteroids |> Enum.count(&visible(&1, {x, y}, asteroids))
  end

  def visible({x, y}, {x, y}, _), do: false

  def visible(from, to, asteroids) do
    false ==
      points_between(from, to)
      |> Enum.any?(fn point -> MapSet.member?(asteroids, point) end)
  end

  def points_between({x1, y1}, {x2, y2}) do
    {dx, dy} = {x2 - x1, y2 - y1}
    gcd = Integer.gcd(dx, dy)
    {sx, sy} = {div(dx, gcd), div(dy, gcd)}
    num = if sx != 0, do: div(dx, sx) - 1, else: div(dy, sy) - 1

    1..num
    |> Enum.map(fn ratio -> {x1 + sx * ratio, y1 + sy * ratio} end)
    |> Enum.take(num)
  end

  @doc """

  """
  def part_2(input) do
    asteroids = input |> parse
    max = asteroids |> Enum.max_by(&asteroids_detected(&1, asteroids))
    asteroids = MapSet.delete(asteroids, max)

    asteroids = vaporize(asteroids, max, 202)
    {x, y} = asteroids |> Enum.at(200 - 1)
    x * 100 + y
  end

  def vaporize(asteroids, laser, remaining),
    do: vaporize(asteroids, laser, :math.pi() / 2, remaining)

  def vaporize(asteroids, laser, laser_angle, remaining, removed \\ [])
  def vaporize(_, _, _, 0, removed), do: removed

  def vaporize(asteroids, laser, laser_angle, remaining, removed) do
    angles =
      Enum.filter(asteroids, &visible(laser, &1, asteroids))
      |> Enum.map(fn {x, y} ->
        angle = angle({x, y}, laser)
        relative_angle = (angle - laser_angle) |> positive_angle
        {relative_angle, angle, {x, y}}
      end)

    {_relative_angle, angle, coord} =
      Enum.min_by(angles, fn {relative_angle, _angle, _coord} ->
        relative_angle
      end)

    asteroids = MapSet.delete(asteroids, coord)
    remaining = Enum.min([remaining - 1, MapSet.size(asteroids)])

    vaporize(asteroids, laser, angle + 0.00000000000001, remaining, removed ++ [coord])
  end

  def angle({x, y}, {mid_x, mid_y}) do
    :math.atan2(mid_y - y, mid_x - x) |> positive_angle
  end

  def positive_angle(angle) when angle < 0, do: angle + 2 * :math.pi()
  def positive_angle(angle), do: angle

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {str, y} -> parse_row(str, y) end)
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
  end

  defp parse_row(row, y) do
    row
    |> String.graphemes()
    |> Enum.map(&(&1 == "#"))
    |> Enum.with_index()
    |> Enum.filter(fn {val, _} -> val end)
    |> Enum.map(fn {_val, x} -> {x, y} end)
    |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))
  end
end
