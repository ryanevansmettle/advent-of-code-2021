#!/usr/bin/env ruby

require_relative '../lib/util'
require 'set'

class Day12 < Scenario

  def initialize
    @is_upper = -> (n) { /[[:upper:]]/.match(n) != nil }
    @is_lower = -> (n) { /[[:lower:]]/.match(n) != nil }

    super
  end

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)
    lines.map { |l| l.split("-") }
  end

  # @param [Array<String>] path
  # @param [String] node
  # @param [Hash<String -> String>] vertices
  # @param [Array<Array<String>>] paths
  # @param [Integer] max_visit
  def traverse(path, node, vertices, paths, max_visit)
    if node == "end"
      paths << path
      return nil
    end

    for n in vertices[node]
      if n == "start"
        next
      end

      if max_visit == 1
        if @is_upper.call(n) || !path.include?(n)
          new_path = path.clone
          new_path << n
          traverse(new_path, n, vertices, paths, max_visit)
        end
      else
        if @is_upper.call(n)
          new_path = path.clone
          new_path << n
          traverse(new_path, n, vertices, paths, max_visit)
          next
        end

        number_of_dupe_lower_case = path.filter { |e| e != "start" && e != "end" }
                                        .filter { |e| @is_lower.call(e) }
                                        .group_by(&:itself).map { |c| c[1].size }.max
        if number_of_dupe_lower_case == nil
          number_of_dupe_lower_case = 0
        end

        num_n_in_path = path.filter { |e| e == n }.count

        if (number_of_dupe_lower_case == 2 && num_n_in_path < 1) ||
          (number_of_dupe_lower_case < 2)
          new_path = path.clone
          new_path << n
          traverse(new_path, n, vertices, paths, max_visit)
        end

      end
    end
    return nil
  end

  def build_vertices(input)
    vertices = {}

    for edge in input
      from, to = edge

      unless vertices.key?(from)
        vertices[from] = Set.new
      end
      vertices[from] << to unless from == "end" || to == "start"

      unless vertices.key?(to)
        vertices[to] = Set.new
      end
      vertices[to] << from unless to == "end" || from == "start"
    end
    vertices
  end

  def part1 (input)
    vertices = build_vertices(input)
    paths = []
    traverse(["start"], "start", vertices, paths, 1)
    paths.size
  end

  def part1_example_expected_result
    226
  end

  def part1_expected_result
    4241
  end

  def part2 (input)
    vertices = build_vertices(input)
    paths = []
    traverse(["start"], "start", vertices, paths, 2)
    paths.size
  end

  def part2_example_expected_result
    3509
  end

  def part2_expected_result
    122134
  end

end

Day12.new
