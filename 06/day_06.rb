#!/usr/bin/env ruby

require_relative '../lib/util'

class Day06 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input).map { |l| l.split(",").map { |i| i.to_i } }.flatten
  end

  def part1 (input)
    (1..80).each { |_|
      additions = []
      input.each_with_index { |t, i|
        input[i] -= 1
        if t == 0
          input[i] = 6
          additions << 8
        end
      }
      input = input + additions
    }
    input.size
  end

  def part1_expected_result
    5934
  end

  def part2 (input)
    timers = Hash.new(0)

    input.each { |i|
      timers[i] += 1
    }

    (1..256).each { |_|
      changes = Hash.new(0)
      timers.each { |t, v|
        if t == 0
          changes[6] += v
          changes[t] -= v

          changes[8] += v
          next
        end
        changes[t - 1] += v
        changes[t] -= v
      }

      changes.each { |t, v|
        timers[t] += v
      }
    }
    timers.values.sum
  end

  def part2_expected_result
    26984457539
  end

end

Day06.new
