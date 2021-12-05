#!/usr/bin/env ruby

require_relative '../lib/util'

class Day05 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)
    lines.map { |l| l.split("->")
                     .map { |s| s.split(",")
                                 .map { |n| n.strip }
                                 .map { |n| n.to_i }
                     }
    }
  end

  def range_ascending(p1, p2)
    if p1 <= p2
      p1..p2
    else
      p2..p1
    end
  end

  # @param [Array<Array<Numeric>>] input
  def walk_line(pair)
    p1 = pair[0]
    p2 = pair[1]
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]

    if dx == 0
      range = range_ascending(p1[1], p2[1])
      range.map { |y| [p1[0], y] }
    else
      range = range_ascending(p1[0], p2[0])
      range.map { |x|
        y = p1[1] + dy * (x - p1[0]) / dx
        [x, y]
      }
    end
  end

  def is_diagonal(p1, p2)
    p1[0] != p2[0] && p1[1] != p2[1]
  end

  # @param [Array] input
  def part1 (input)
    points = []
    input.each { |pair|
      next if is_diagonal(pair[0], pair[1])
      points << walk_line(pair)
    }

    points.flatten(1).tally.filter { |_, c| c >= 2 }.count
  end

  def part1_expected_result
    5
  end

  # @param [Array] input
  def part2 (input)
    points = input.map { |pair| walk_line(pair) }

    points.flatten(1).tally.filter { |_, c| c >= 2 }.count
  end

  def part2_expected_result
    12
  end

end

Day05.new
