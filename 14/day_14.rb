#!/usr/bin/env ruby

require_relative '../lib/util'

class Day14 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)
    template = lines[0]

    rules = {}

    (2..lines.size - 1).each { |i|
      s = lines[i].split(/->/)
      rules[s[0].strip] = s[1].strip
    }

    [template, rules]
  end

  def find_delta(pair_counts, template)
    counts_by_character = find_counts_by_character(pair_counts, template)
    counts_by_character.values.max - counts_by_character.values.min
  end

  def find_counts_by_character(pair_counts, template)
    counts_by_character = Hash.new(0)
    pair_counts.each { |p, c| counts_by_character[p[0]] += c }
    counts_by_character[template[-1]] += 1
    counts_by_character
  end

  def compute_pairs_after_steps (template, rules, steps, debug = false)
    pairs = Hash.new(0)
    (0..template.size - 2).each { |i|
      pairs[template.chars[i..i + 1].join] += 1
    }

    (1..steps).each { |step|
      prev_pairs = pairs.dup
      pairs = Hash.new(0)
      prev_pairs.each { |p, v|
        insert = rules[p]
        pairs[p[0] + insert] += v
        pairs[insert + p[1]] += v
      }

      puts "After step #{step}: #{find_counts_by_character(pairs, template)}" if debug
    }
    pairs
  end

  def part1 (input)
    template, rules = *input
    counts = compute_pairs_after_steps(template, rules, 10)
    find_delta(counts, template)
  end

  def part1_example_expected_result
    1588
  end

  def part1_expected_result
    2587
  end

  def part2 (input)
    template, rules = *input
    counts = compute_pairs_after_steps(template, rules, 40)
    find_delta(counts, template)
  end

  def part2_example_expected_result
    2188189693529
  end

  def part2_expected_result
    3318837563123
  end

end

Day14.new
