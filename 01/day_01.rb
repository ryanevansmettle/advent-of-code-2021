#!/usr/bin/env ruby

input = File.read("input.txt").split.map { |l| l.to_i }

# @param [Array] input
# @return [Array]
def sequential_increases (input)
  input.each_cons(2).map { |a, b| [a, b] }.filter { |a, b| b > a }
end

# @param [Array] input
def part1 (input)
  sequential_increases(input).size
end

# @param [Array] input
def part2 (input)
  window_sums = input.each_cons(3).map { |w| w.sum }
  sequential_increases(window_sums).size
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"