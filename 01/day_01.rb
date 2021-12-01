#!/usr/bin/env ruby

input = File.read("input.txt").split.map { |l| l.to_i }

def part1 (input, debug)
  increases = []
  last = nil
  input.each { |current|
    if last == nil
      puts "#{current} (N/A - no previous measurement)" if debug
      last = current
      next
    end
    if current > last
      puts "#{current} (increased)" if debug
      increases << current
    else
      puts "#{current} (decreased)" if debug
    end
    last = current
  }
  increases.size
end

def part2 (input, debug)
  increases = []
  input.each_with_index do |_, i,|
    if i > 2
      last_window_sum = input[i - 3..i - 1].sum
      current_window_sum = input[i - 2..i].sum

      if current_window_sum > last_window_sum
        puts "#{current_window_sum} (increased)" if debug
        increases << current_window_sum
      elsif current_window_sum == last_window_sum
        puts "#{current_window_sum} (no change)" if debug
      else
        puts "#{current_window_sum} (decreased)" if debug
      end
    end
  end

  increases.size
end

puts "Part 1: #{part1(input, false)}"
puts "Part 2: #{part2(input, false)}"