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

class Scenario

  def initialize
    @part1ExampleFile = "input_example.txt"
    @part1RealFile = "input_real.txt"

    @part2ExampleFile = "input_example.txt"
    @part2RealFile = "input_real.txt"

    self.solve
  end

  def print_example_result(partIdentifier, result, expected_result)
    if result == expected_result
      pass = "PASS".on_green
      puts "[#{pass}] Part #{partIdentifier} Example: #{expected_result}"
    else
      fail = "FAIL".on_red
      puts "[#{fail}] Part #{partIdentifier} Example: expected #{expected_result}, was #{result}"
    end
  end

  def solve
    name = self.class.name.gsub(/(?<=[a-z])(?=[0-9])/, ' ')
    puts "#{name}\n\n"

    p1ExampleInput = grok_input(Input.read_input(@part1ExampleFile))
    p2ExampleInput = grok_input(Input.read_input(@part2ExampleFile))

    part1ExampleResult = self.part1(p1ExampleInput)
    print_example_result(
      "1",
      part1ExampleResult,
      self.part1_expected_result
    )

    part2ExampleResult = self.part2(p2ExampleInput)
    print_example_result(
      "2",
      part2ExampleResult,
      self.part2_expected_result
    )

    puts "\n----------\n\n"

    p1RealInput = grok_input(Input.read_input(@part1RealFile))
    p2RealInput = grok_input(Input.read_input(@part2RealFile))
    p1RealResult = self.part1(p1RealInput)
    p2RealResult = self.part2(p2RealInput)

    puts "Part 1: #{p1RealResult}"
    puts "Part 2: #{p2RealResult}"

    if part1ExampleResult != self.part1_expected_result || part2ExampleResult != self.part2_expected_result
      exit 1
    end
  end

  def self.grok_input(input)
    raise NotImplementedError
  end

  def self.part1_expected_result
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

