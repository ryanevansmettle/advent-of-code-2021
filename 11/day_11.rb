#!/usr/bin/env ruby

require_relative '../lib/util'

class Day11 < Scenario

  # @param [File] octopuses
  def grok_input(octopuses)
    Input.to_lines(octopuses).map { |l| l.split("").map { |c| c.to_i } }
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Array<Integer>>] octopuses
  # @return [Array<Array<Integer>]
  def neighbours(x, y, octopuses)
    neighbours = []

    neighbours << [x, y - 1] if y > 0
    neighbours << [x, y + 1] if y < octopuses.size - 1
    neighbours << [x - 1, y] if x > 0
    neighbours << [x + 1, y] if x < octopuses[0].size - 1

    neighbours << [x + 1, y + 1] if x < octopuses[0].size - 1 && y < octopuses.size - 1
    neighbours << [x + 1, y - 1] if x < octopuses[0].size - 1 && y > 0
    neighbours << [x - 1, y + 1] if x > 0 && y < octopuses.size - 1
    neighbours << [x - 1, y - 1] if x > 0 && y > 0

    neighbours
  end

  # @param [Array<Array<Integer>>] octopuses
  # @return [Array<Integer>]
  def get_flashing(octopuses)
    flashing = []
    (0..octopuses.length - 1).each { |y|
      (0..octopuses[0].length - 1).each { |x|
        v = octopuses[y][x]
        if v != :flashed && v > 9
          flashing << [x, y]
        end
      }
    }
    flashing
  end

  # @param [Array<Array<Integer>>] octopuses
  # @return [Array<Array<Integer>>]
  def increment_all(octopuses)
    octopuses.map { |l| l.map { |i| i + 1 } }
  end

  # @param [Array<Array<Integer>>] octopuses
  # @return [Integer]
  def count_flashes(octopuses)
    octopuses.flatten(1).filter { |i| i == :flashed }.count
  end

  # @param [Array<Array<Integer>>] octopuses
  def reset_flashes(octopuses)
    (0..octopuses.length - 1).each { |y|
      (0..octopuses[0].length - 1).each { |x|
        if octopuses[y][x] == :flashed
          octopuses[y][x] = 0
        end
      }
    }
  end

  # @param [Integer] step
  # @param [Array<Array<Integer>>] octopuses
  def print_map(step, octopuses)
    str = octopuses.map { |l| l.join }.join("\n")
    puts "After step #{step}:\n#{str}\n\n"
  end

  # @param [Array<Array<Integer>>] octopuses
  def flash(octopuses)
    flashing = get_flashing(octopuses)

    until flashing.empty?
      flashing.each { |x, y|
        neighbours(x, y, octopuses).each { |n|
          if octopuses[n[1]][n[0]] != :flashed
            octopuses[n[1]][n[0]] += 1
          end
        }
        octopuses[y][x] = :flashed
      }
      flashing = get_flashing(octopuses)
    end
    flashing
  end

  # @param [Array<Array<Integer>>] octopuses
  def part1 (octopuses)
    flashes = 0
    (1..100).each { |_|
      octopuses = increment_all(octopuses)

      flash(octopuses)

      flashes += count_flashes(octopuses)
      reset_flashes(octopuses)
    }

    flashes
  end

  def part1_example_expected_result
    1656
  end

  def part1_expected_result
    1617
  end

  def all_are_flashing(octopuses)
    octopuses.flatten(1).filter { |i| i != :flashed }.count == 0
  end

  # @param [Array<Array<Integer>>] octopuses
  def part2 (octopuses)
    step = 1
    while true
      octopuses = increment_all(octopuses)

      flash(octopuses)

      if all_are_flashing(octopuses)
        return step
      end
      reset_flashes(octopuses)

      step += 1
    end

    step
  end

  def part2_example_expected_result
    195
  end

  def part2_expected_result
    258
  end

end

Day11.new
