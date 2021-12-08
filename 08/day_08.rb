#!/usr/bin/env ruby

require_relative '../lib/util'

#noinspection RubyClassVariableUsageInspection
class Day08 < Scenario

  # @type [Hash<Integer, Integer>]
  @@known_mappings = {
    2 => 1,
    3 => 7,
    4 => 4,
    7 => 8
  }

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
         .map { |l| l.split("|").map { |s| s.split(" ") } }
  end

  def part1 (input)
    input.map(&:last)
         .flatten(1)
         .filter { |str| @@known_mappings.has_key?(str.chars.uniq.count) }
         .count
  end

  def part1_example_expected_result
    26
  end

  def part1_expected_result
    321
  end

  # @param [String] str
  # @param [Hash<String, Integer>] known_output_map
  # @return [Array<String, Integer>]
  def map_string_to_digit(str, known_output_map)
    output_string_for_known_n = -> (n) { known_output_map.filter { |_, v| v == n }.first.first }
    segments_in_common_with_number = -> (str, n) { str.count(output_string_for_known_n.call(n)) }

    if known_output_map.has_key?(str)
      return [str, known_output_map[str]]
    end

    ###
    # Using example:
    #
    #  dddd
    # e    a
    # e    a
    #  ffff
    # g    b
    # g    b
    #  cccc
    #
    # 1 covers segments {a, b}
    # 2 covers segments {d, a, f, g, c}
    # 3 covers segments {d, a, f, b, c}
    # 4 covers segments {e, f, a, b}
    # 5 covers the segments {d, e, f, b, c}
    # 6 covers segments {d, e, g, c, b, f}
    # 7 covers segments {d, a, b}
    # 8 covers segments {a, b, c, d, e, f, g}
    # 9 covers segments {f, e, d, a, b, c}
    # 0 covers segments {d, e, g, c, b, a}
    #
    # By comparing the overlap of the segments numbers we know (1, 4, 7, 8) with the segments covered by the strings
    # then we can determine the number they represent.
    ###

    if str.length == 6
      if segments_in_common_with_number.call(str, 4) == 4
        val = 9
      elsif segments_in_common_with_number.call(str, 7) == 2
        val = 6
      else
        val = 0
      end
    else
      if segments_in_common_with_number.call(str, 1) == 2
        val = 3
      elsif segments_in_common_with_number.call(str, 4) == 3
        val = 5
      else
        val = 2
      end
    end

    [str, val]
  end

  # @param [Array<String>] input_line
  # @return [Hash<String, Integer>]
  def output_map_for_input(input_line)
    known_output_map = @@known_mappings
                         .map { |k, v| [input_line.filter { |s| s.length == k }.first, v] }
                         .to_h
    input_line.map { |str| map_string_to_digit(str, known_output_map) }
              .map { |k, v| [k.chars.uniq.sort.join, v] }
              .to_h
  end

  # @param [Array<Array<String>>] input
  def part2 (input)
    input.map { |input_line, output_line|
      output_map = output_map_for_input(input_line)

      output_line.map { |out|
        sorted = out.chars.uniq.sort.join
        output_map[sorted].to_s
      }.join.to_i

    }.sum
  end

  def part2_example_expected_result
    61229
  end

  def part2_expected_result
    1028926
  end
end

Day08.new
