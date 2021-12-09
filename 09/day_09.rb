#!/usr/bin/env ruby

require_relative '../lib/util'

class Day09 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)
    lines.map { |l| l.split("").map { |n| n.to_i } }
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Array<Integer>>] input
  # @return [Array<Array<Integer>]
  def immediate_neighbours(x, y, input)
    neighbours = []

    neighbours << [x, y - 1] if y > 0
    neighbours << [x, y + 1] if y < input.size - 1
    neighbours << [x - 1, y] if x > 0
    neighbours << [x + 1, y] if x < input[0].size - 1

    neighbours
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Array<Integer>>] input
  # @return [Array<Integer>]
  def immediate_neighbours_values(x, y, input)
    immediate_neighbours(x, y, input).map { |nx, ny| input[ny][nx] }
  end

  # @param [Array<Array<Integer>>] input
  # @return [Array<Array<Integer>]
  def lowest_points(input)
    input.each_with_index.map { |y, yi|
      y.each_with_index.map { |x, xi|
        (x < immediate_neighbours_values(xi, yi, input).min) ? [xi, yi] : nil
      }
    }.flatten(1).filter { |a| !a.nil? }
  end

  # @param [Array<Array<Integer>>] input
  def part1 (input)
    lowest_points(input)
      .map { |x, y| input[y][x] }
      .map { |n| n + 1 }.sum
  end

  def part1_example_expected_result
    15
  end

  def part1_expected_result
    545
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Array<Integer>>] input
  # @param [Array<Array<Integer>>] visited
  # @return [Array<Array<Integer>]
  def discover_basin_around_point(x, y, input, visited = [])
    if visited.include?([x, y])
      return visited
    end

    visited << [x, y]

    immediate_neighbours(x, y, input)
      .filter { |nx, ny| input[ny][nx] != 9 }
      .reduce(visited) { |updated_visited, neighbour| discover_basin_around_point(neighbour[0], neighbour[1], input, updated_visited) }

    visited
  end

  # @param [Array<Array<Integer>>] input
  def part2 (input)
    lowest_points(input)
      .map { |x, y| discover_basin_around_point(x, y, input) }
      .map(&:size)
      .max(3)
      .inject(:*)
  end

  def part2_example_expected_result
    1134
  end

  def part2_expected_result
    950600
  end

end

Day09.new
