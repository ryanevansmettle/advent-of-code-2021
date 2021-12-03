#!/usr/bin/env ruby

require_relative '../lib/util'

class Day03 < Scenario

  # @param [Array<String>] binary_strings
  # @param [Numeric] position
  # @return [Hash]
  def frequency_bucket_at_position(binary_strings, position)
    freq = { "0" => 0, "1" => 0 }
    binary_strings.each { |bitstring|
      freq[bitstring[position]] += 1
    }
    freq
  end

  # @param [Hash] frequency_bucket
  # @return [String]
  def most_common(frequency_bucket)
    frequency_bucket.max_by { |f| f[1] }[0]
  end

  # @param [Hash] frequency_bucket
  # @return [String]
  def least_common(frequency_bucket)
    frequency_bucket.min_by { |f| f[1] }[0]
  end

  # @param [Hash] frequency_bucket
  # @return [Boolean]
  def equally_common(frequency_bucket)
    frequency_bucket.values.uniq.count == 1
  end

  # @param [Array<String>] binary_strings
  # @param [Numeric] position
  # @return [String]
  def ogr_criteria(binary_strings, position)
    freq_bucket = frequency_bucket_at_position(binary_strings, position)
    return "1" if equally_common(freq_bucket)
    most_common(freq_bucket)
  end

  # @param [Array<String>] binary_strings
  # @param [Numeric] position
  # @return [String]
  def c02_criteria(binary_strings, position)
    freq_bucket = frequency_bucket_at_position(binary_strings, position)
    return "0" if equally_common(freq_bucket)
    least_common(freq_bucket)
  end

  # @param [Array<String>] binary_strings
  # @return [String]
  def ogr(binary_strings)
    _ogr(binary_strings.clone, 0)
  end

  # @param [Array<String>] remaining_strings
  # @param [Numeric>] position
  # @return [String]
  def _ogr(remaining_strings, position)
    ogr_criteria = ogr_criteria(remaining_strings, position)
    remaining_strings = remaining_strings.filter { |s| s[position] == ogr_criteria }

    if remaining_strings.size == 1
      return remaining_strings[0]
    end
    _ogr(remaining_strings, position += 1)
  end

  # @param [Array<String>] binary_strings
  # @return [String]
  def c02(binary_strings)
    _c02(binary_strings.clone, 0)
  end

  # @param [Array<String>] remaining_strings
  # @param [Numeric>] position
  # @return [String]
  def _c02(remaining_strings, position)
    c02_criteria = c02_criteria(remaining_strings, position)
    remaining_strings = remaining_strings.filter { |s| s[position] == c02_criteria }

    if remaining_strings.size == 1
      return remaining_strings[0]
    end

    _c02(remaining_strings, position += 1)
  end

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
  end

  def part1 (input)
    gamma_str = ""
    epsilon_str = ""
    num_bits = input[0].length
    (0..num_bits - 1).each { |pos|
      bucket = frequency_bucket_at_position(input, pos)

      gamma_str << most_common(bucket)
      epsilon_str << least_common(bucket)
    }

    gamma_str.to_i(2) * epsilon_str.to_i(2)
  end

  def part1_expected_result
    198
  end

  def part2 (input)
    ogr(input).to_i(2) * c02(input).to_i(2)
  end

  def part2_expected_result
    230
  end

end

Day03.new
