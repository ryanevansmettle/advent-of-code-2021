#!/usr/bin/env ruby

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
  (d, n) = instruction.split(/\s/)
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

input = File.open("input.txt").each_line
            .map { |l| parse_instruction(l) }

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

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
