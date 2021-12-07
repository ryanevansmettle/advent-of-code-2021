#!/usr/bin/env ruby

require_relative '../lib/util'

class Day06 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input).map { |l| l.split(",").map { |i| i.to_i } }.flatten
  end

  # @param [Hash] population
  # @param [Numeric] days
  # @return [Numeric]
  def simulate_growth(population, days)
    (1..days).each { |_|
      changes = Hash.new(0)
      population.each { |t, v|
        if t == 0
          # Reset 0 to 6
          changes[6] += v
          changes[t] -= v

          # Spawn new ones
          changes[8] += v
          next
        end
        changes[t - 1] += v
        changes[t] -= v
      }

      changes.each { |t, v|
        population[t] += v
      }
    }
    population.values.sum
  end

  def input_to_population_map(input)
    population = Hash.new(0)
    input.each { |i|
      population[i] += 1
    }
    population
  end

  def part1 (input)
    simulate_growth(input_to_population_map(input), 80)
  end

  def part1_example_expected_result
    5934
  end

  def part1_expected_result
    380243
  end

  def part2 (input)
    simulate_growth(input_to_population_map(input), 256)
  end

  def part2_example_expected_result
    26984457539
  end

  def part2_expected_result
    1708791884591
  end

end

Day06.new
