#!/usr/bin/env ruby

require_relative '../lib/util'

input = Input.read_lines

def frequency_bucket_at_position(binary_strings, position)
  freq = { "0" => 0, "1" => 0 }
  binary_strings.each { |binstr|
    bit = binstr[position]
    freq[bit] = freq[bit] + 1
  }
  freq
end

def most_common(frequency_bucket)
  frequency_bucket.max_by { |k| k[1] }[0]
end

def least_common(frequency_bucket)
  frequency_bucket.min_by { |k| k[1] }[0]
end

def equally_common(frequency_bucket)
  frequency_bucket["0"] == frequency_bucket["1"]
end

def ogr_criteria(binary_strings, position)
  freq_bucket = frequency_bucket_at_position(binary_strings, position)
  return "1" if equally_common(freq_bucket)
  most_common(freq_bucket)
end

def c02_criteria(binary_strings, position)
  freq_bucket = frequency_bucket_at_position(binary_strings, position)
  return "0" if equally_common(freq_bucket)
  least_common(freq_bucket)
end

def ogr(binary_strings)
  num_bits = binary_strings[0].length

  remaining_strings = binary_strings.clone

  (0..num_bits - 1).each { |pos|
    ogr_criteria = ogr_criteria(remaining_strings, pos)
    remaining_strings = remaining_strings.filter { |s| s[pos] == ogr_criteria }

    break if remaining_strings.size == 1
  }
  remaining_strings[0]
end

def c02(binary_strings)
  num_bits = binary_strings[0].length

  remaining_strings = binary_strings.clone

  (0..num_bits - 1).each { |pos|
    c02_criteria = c02_criteria(remaining_strings, pos)
    remaining_strings = remaining_strings.filter { |s| s[pos] == c02_criteria }

    break if remaining_strings.size == 1
  }
  remaining_strings[0]
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

def part2 (input)
  ogr(input).to_i(2) * c02(input).to_i(2)
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
