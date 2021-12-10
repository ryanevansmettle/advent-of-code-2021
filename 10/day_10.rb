#!/usr/bin/env ruby

require_relative '../lib/util'

class Day10 < Scenario

  def initialize
    @char_mappings = {
      '[' => ']',
      '{' => '}',
      '(' => ')',
      '<' => '>'
    }
    @is_opener = -> (token) { @char_mappings.key?(token) }
    @is_closer = -> (token) { @char_mappings.value?(token) }

    super
  end

  # @param [File] input
  # @return [Array<Array<String>>]
  def grok_input(input)
    Input.to_lines(input).map { |l| l.split("") }
  end

  # @param [Array<String>] line
  # @return [Array<Array<String>, Array<String>>] The un-closed chunks and the tokens, if any, that remain after an illegal character is found.
  def parse_line_until_able(line)
    chunk_stack = []
    line.each_with_index { |token, i|
      if @is_opener.call(token)
        chunk_stack << token
      end
      if @is_closer.call(token)
        current_chunk = chunk_stack.pop
        if @char_mappings[current_chunk] != token
          return [chunk_stack, line[i, line.length]]
        end
      end
    }

    [chunk_stack, []]
  end

  # @param [Array<String>] line
  # @return [Array<String>] Parses the line and returns the tokens, if any, that were used to complete the line.
  def complete_line(line)
    chunk_stack, remaining = parse_line_until_able(line)

    unless remaining.empty?
      # nothing to complete for corrupted lines
      return []
    end

    appended = []
    until chunk_stack.empty?
      opener = chunk_stack.pop
      closer = @char_mappings[opener]
      appended << closer
    end
    appended
  end

  # @param [Array<Array<String>>] input
  def part1 (input)
    score_mappings = {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137
    }

    input.map { |line| parse_line_until_able(line)[1] }
         .reject(&:empty?)
         .map { |remaining| remaining.first }
         .map { |token| score_mappings[token] }.sum
  end

  def part1_example_expected_result
    26397
  end

  def part1_expected_result
    367227
  end

  # @param [Array<Array<String>>] input
  def part2 (input)
    score_mappings = {
      ')' => -> (score) { score * 5 + 1 },
      ']' => -> (score) { score * 5 + 2 },
      '}' => -> (score) { score * 5 + 3 },
      '>' => -> (score) { score * 5 + 4 },
    }

    scores = input.map { |line| complete_line(line) }
                  .reject(&:empty?)
                  .map { |l| l.reduce(0) { |score, t| score_mappings[t].call(score) } }
    Maths.median(scores)
  end

  def part2_example_expected_result
    288957
  end

  def part2_expected_result
    3583341858
  end

end

Day10.new
