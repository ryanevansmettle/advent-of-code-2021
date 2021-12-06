#!/usr/bin/env ruby

require_relative '../lib/util'

class Day01 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input).map { |i| i.to_i }
  end

  # @param [Array] input
  # @return [Array]
  def sequential_increases (input)
    input.each_cons(2).map { |a, b| [a, b] }.filter { |a, b| b > a }
  end

  # @param [Array] input
  def part1 (input)
    sequential_increases(input).size
  end

  def part1_expected_result
    7
  end

  # @param [Array] input
  def part2 (input)
    window_sums = input.each_cons(3).map { |w| w.sum }
    sequential_increases(window_sums).size
  end

  def part2_expected_result
    5
  end

end

Day01.new
