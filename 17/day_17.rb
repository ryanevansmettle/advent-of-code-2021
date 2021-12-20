#!/usr/bin/env ruby

require_relative '../lib/util'

class Day17 < Scenario

  def to_target_range(str)
    ints = str.scan(/(-?\d+)/).flatten.map { |n| n.to_i }
    [ints[0..1], ints[2..3]]
  end

  def simulate_with_velocity(initial_velocity, target_range)
    is_in_x_range = -> (x) { x >= target_range[0][0] && x <= target_range[0][1] }
    is_in_y_range = -> (y) { y >= target_range[1][0] && y <= target_range[1][1] }
    is_in_range = -> (x, y) { is_in_x_range.call(x) && is_in_y_range.call(y) }
    is_over_shoot = -> (x, y) { x > target_range[0][1] || y < target_range[1][0] }

    x, y = [0, 0]
    x_velocity, y_velocity = initial_velocity

    while true
      x += x_velocity
      y += y_velocity

      if x_velocity > 0
        x_velocity -= 1
      elsif x_velocity < 0
        x_velocity += 1
      end

      y_velocity -= 1

      if is_in_range.call(x, y)
        return true
      end
      if is_over_shoot.call(x, y)
        return false
      end
    end
  end

  def determine_all(target_range)
    left_x = target_range[0][1]
    top_y = target_range[1][0].abs

    valid = []

    for y in -top_y..top_y
      for x in 0..left_x
        valid << [x, y] if simulate_with_velocity([x, y], target_range)
      end
    end

    valid.uniq
  end

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input).map { |l| to_target_range(l) }[0]
  end

  def part1 (target_range)
    v = -target_range[1].min - 1
    v * (v + 1) / 2
  end

  def part1_example_expected_result
    45
  end

  def part1_expected_result
    2775
  end

  def part2 (target_range)
    determine_all(target_range).count
  end

  def part2_example_expected_result
    112
  end

  def part2_expected_result
    1566
  end

end

Day17.new
