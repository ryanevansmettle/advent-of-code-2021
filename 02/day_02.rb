#!/usr/bin/env ruby

require_relative '../lib/util'

class Day02 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.read_lines_and_tokenise(input)
         .map(&method(:parse_instruction))
  end

  class Instruction
    # @return [Symbol]
    attr_accessor :direction
    # @return [Numeric]
    attr_accessor :units

    def initialize(direction, units)
      @direction = direction
      @units = units
    end
  end

  # @param [String] instruction
  # @return [Instruction]
  def parse_instruction (instruction)
    (d, n) = instruction
    case d
    when "forward"
      dir = :fwd
    when "down"
      dir = :down
    else
      dir = :up
    end

    Instruction.new(dir, n.to_i)
  end

  # @param [Array] input
  # @return [Array]
  def sequential_increases (input)
    input.each_cons(2).map { |a, b| [a, b] }.filter { |a, b| b > a }
  end

  # @param [Array<Instruction>] input
  def part1 (input)
    depth = 0
    horizontal_position = 0

    input.each { |instruction|
      case instruction.direction
      when :down
        depth += instruction.units
      when :up
        depth -= instruction.units
      else
        horizontal_position += instruction.units
      end
    }

    depth * horizontal_position
  end

  def part1_example_expected_result
    150
  end

  def part1_expected_result
    2102357
  end

  # @param [Array<Instruction>] input
  def part2 (input)
    depth = 0
    horizontal_position = 0
    aim = 0

    input.each { |instruction|
      case instruction.direction
      when :down
        aim += instruction.units
      when :up
        aim -= instruction.units
      else
        horizontal_position += instruction.units
        depth += aim * instruction.units
      end
    }

    depth * horizontal_position
  end

  def part2_example_expected_result
    900
  end

  def part2_expected_result
    2101031224
  end

end

Day02.new
