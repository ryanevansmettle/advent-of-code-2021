#!/usr/bin/env ruby

require_relative '../lib/util'

class Day07 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input).map { |l| l.split(",").map { |n| n.to_i } }.flatten
  end

  # @param [Array<Integer>] positions
  # @return Integer
  def median(positions)
    sorted = positions.sort
    mid = positions.length / 2
    positions.length.even? ?
      sorted[mid - 1, 2].sum / 2
      : sorted[mid]
  end

  # @param [Array<Integer>] positions
  # @param [Integer] target
  # @param [Proc] cost_function
  # @return Integer
  def calculate_total_fuel_spend(positions, target, cost_function)
    positions
      .map { |pos|
        delta = (pos - target).abs
        cost_function.call delta
      }
      .sum
  end

  # @param [Array<Integer>] input
  def part1 (input)
    target = median(input)
    calculate_total_fuel_spend(input, target, -> (cost) { cost })
  end

  def part1_expected_result
    37
  end

  # @param [Array<Integer>] input
  def part2 (input)
    (input.min..input.max)
      .map { |n| calculate_total_fuel_spend(input, n, -> (pos) { (pos * (pos + 1)) / 2 }) }
      .min
  end

  def part2_expected_result
    168
  end

end

Day07.new
