#!/usr/bin/env ruby

def parse_instr(d, n)
  if d == "forward"
    dir = :fwd
  elsif d == "down"
    dir = :down
  else
    dir = :up
  end

  [dir, n.to_i]
end

input = File.read("input.txt").split("\n").map { |l| l.split(" ") }.map { |d, n| parse_instr(d, n) }

def part1 (input)
  depth = 0
  hor = 0

  input.each { |inst|
    d = inst[0]
    n = inst[1]
    if d == :down
      depth += n
    elsif d == :up
      depth -= n
    else
      hor += n
    end
  }

  depth * hor
end

def part2 (input)
  depth = 0
  hor = 0
  aim = 0

  input.each { |inst|
    d = inst[0]
    n = inst[1]
    if d == :down
      aim += n
    elsif d == :up
      aim -= n
    else
      hor += n
      depth += (aim * n)
    end
  }

  depth * hor
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
