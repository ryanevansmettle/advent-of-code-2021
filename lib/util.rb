require 'colorize'

module Input

  # @param [String] filename
  # @return [File]
  def self.read_input(filename)
    File.open(filename)
  end

  # @param [File] file
  # @return [Array<String>]
  def self.to_lines(file)
    return file.each_line.map { |l| l.chomp }
  end

  # @param [File] file
  # @return [Array<Array>]
  def self.read_lines_and_tokenise(file)
    return file.each_line.map { |l| Grok.tokenise_spaces(l) }
  end

end

module Grok
  # @param [String] str
  # @param [Regexp] regex
  # @return [Array]
  def self.tokenise(str, regex)
    return str.split(regex)
  end

  # @param [String] str
  # @return [Array]
  def self.tokenise_spaces(str)
    return tokenise(str, /\s/)
  end
end

module Maths

  # @param [Array<Integer>] values
  # @return [Integer]
  def self.median(values)
    sorted = values.sort
    mid = values.length / 2
    values.length.even? ?
      sorted[mid - 1, 2].sum / 2
      : sorted[mid]
  end

end

class Scenario

  def initialize
    @part1_example_file = "input_example.txt"
    @part1_real_file = "input_real.txt"

    @part2_example_file = "input_example.txt"
    @part2_real_file = "input_real.txt"

    self.solve
  end

  def print_result(part_identifier, result, expected_result)
    if result == expected_result
      pass = "PASS".on_green
      puts "[#{pass}] Part #{part_identifier}: #{expected_result}"
    else
      fail = "FAIL".on_red
      puts "[#{fail}] Part #{part_identifier}: expected #{expected_result}, was #{result}"
    end
  end

  def solve
    name = self.class.name.gsub(/(?<=[a-z])(?=[0-9])/, ' ')
    puts "#{name}\n\n"

    p1_example_input = grok_input(Input.read_input(@part1_example_file))
    p2_example_input = grok_input(Input.read_input(@part2_example_file))

    part1_example_result = self.part1(p1_example_input)
    print_result(
      "1 Example",
      part1_example_result,
      self.part1_example_expected_result
    )

    part2_example_result = self.part2(p2_example_input)
    print_result(
      "2 Example",
      part2_example_result,
      self.part2_example_expected_result
    )

    puts "\n----------\n\n"

    p1_real_input = grok_input(Input.read_input(@part1_real_file))
    p2_real_input = grok_input(Input.read_input(@part2_real_file))

    part1_real_result = self.part1(p1_real_input)
    print_result(
      "1",
      part1_real_result,
      self.part1_expected_result
    )

    part2_real_result = self.part2(p2_real_input)
    print_result(
      "2",
      part2_real_result,
      self.part2_expected_result
    )

    if part1_example_result != self.part1_example_expected_result ||
      part2_example_result != self.part2_example_expected_result ||
      part1_real_result != self.part1_expected_result ||
      part2_real_result != self.part2_expected_result
      exit 1
    end
  end

  def self.grok_input(input)
    raise NotImplementedError
  end

  def self.part1_example_expected_result
    raise NotImplementedError
  end

  def self.part1_expected_result
    raise NotImplementedError
  end

  def self.part2_example_expected_result
    raise NotImplementedError
  end

  def self.part2_expected_result
    raise NotImplementedError
  end

  def self.part1(input)
    raise NotImplementedError
  end

  def self.part2(input)
    raise NotImplementedError
  end

end

