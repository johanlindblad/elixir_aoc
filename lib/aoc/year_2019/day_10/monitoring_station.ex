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

  def asteroids_detected({col, row}, asteroids) do
    asteroids |> Enum.count(&visible(&1, {col, row}, asteroids))
  end

  def visible({col, row}, {col, row}, _), do: false

  def visible(_from = {col, row}, _to = {col2, row2}, asteroids) do
    # IO.inspect(asteroids |> Enum.filter(&blocking({col, row}, {col2, row2}, &1)))
    blocking = asteroids |> Enum.count(&blocking({col, row}, {col2, row2}, &1))
    blocking == 0
  end

  def blocking({col, row}, _, {col, row}), do: false
  def blocking(_, {col2, row2}, {col2, row2}), do: false

  def blocking({col, row}, {col2, row2}, {mcol, mrow}) do
    # https://stackoverflow.com/questions/11907947/how-to-check-if-a-point-lies-on-a-line-between-2-other-points
    dxc = mcol - col
    dyc = mrow - row
    dxl = col2 - col
    dyl = row2 - row

    cross = dxc * dyl - dyc * dxl

    if cross != 0 do
      false
    else
      if abs(dyl) >= abs(dxl) do
        if dyl > 0 do
          row <= mrow && mrow <= row2
        else
          row2 <= mrow && mrow <= row
        end
      else
        if dxl > 0 do
          col <= mcol && mcol <= col2
        else
          col2 <= mcol && mcol <= col
        end
      end
    end
  end

  @doc """

  """
  def part_2(input) do
    asteroids = input |> parse
    max = asteroids |> Enum.max_by(&asteroids_detected(&1, asteroids))
    asteroids = MapSet.delete(asteroids, max)

    asteroids = vaporize(asteroids, max, 202)
    {col, row} = asteroids |> Enum.at(200 - 1)
    col * 100 + row
  end

  def vaporize(asteroids, laser, remaining),
    do: vaporize(asteroids, laser, :math.pi() / 2, remaining)

  def vaporize(asteroids, laser, laser_angle, remaining, removed \\ [])
  def vaporize(_, _, _, 0, removed), do: removed

  def vaporize(asteroids, laser, laser_angle, remaining, removed) do
    case MapSet.size(asteroids) do
      0 ->
        removed

      _ ->
        angles =
          Enum.filter(asteroids, &visible(laser, &1, asteroids))
          |> Enum.map(fn {col, row} ->
            {angle({col, row}, laser), {col, row}}
          end)

        filtered =
          Enum.filter(angles, fn {angle, _pos} ->
            angle - laser_angle >= 0
          end)

        {angle, coord} =
          case filtered do
            [] ->
              Enum.min_by(angles, fn {angle, _coord} ->
                angle - laser_angle
              end)

            _ ->
              Enum.min_by(filtered, fn {angle, _coord} ->
                angle - laser_angle
              end)
          end

        asteroids = MapSet.delete(asteroids, coord)

        vaporize(asteroids, laser, angle + 0.00000000000001, remaining - 1, removed ++ [coord])
    end
  end

  def angle({x, y}, {mid_x, mid_y}) do
    :math.atan2(mid_y - y, mid_x - x)
  end

  def parse(input) do
    # row, col
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {str, num} -> parse_row(str, num) end)
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
  end

  defp parse_row(row, row_num) do
    row
    |> String.graphemes()
    |> Enum.map(&(&1 == "#"))
    |> Enum.with_index()
    |> Enum.filter(fn {val, _pos} -> val end)
    |> Enum.map(fn {_val, pos} -> {pos, row_num} end)
    |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))
  end
end
