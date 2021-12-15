#!/usr/bin/env ruby

require_relative '../lib/util'

require 'rgl/adjacency'
require 'rgl/traversal'
require 'rgl/dijkstra'

class Day15 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)
    lines.map { |l| l.split("").map { |c| c.to_i } }
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Array<Array<Integer>>] input
  # @return [Array<Array<Integer>]
  def neighbours(x, y, input)
    neighbours = []

    neighbours << [x, y - 1] if y > 0
    neighbours << [x, y + 1] if y < input.size - 1
    neighbours << [x - 1, y] if x > 0
    neighbours << [x + 1, y] if x < input[0].size - 1

    neighbours
  end

  # @param [Array<Array<Integer>>] map
  # @return [Hash[Array<Integer> -> Integer]]
  def build_edge_weight_map(map)
    width = map[0].size
    index_of = -> (x, y) { (y * width) + x }

    edge_weights = {}
    map.each_with_index.each { |line, li|
      line.each_with_index.each { |_, si|
        i = index_of.call(si, li)
        neighbours(si, li, map).each { |n|
          ni = index_of.call(n[0], n[1])
          edge_weights[[i, ni]] = map[n[1]][n[0]]
        }
      }
    }
    edge_weights
  end

  # @param [Array<Array<Integer>>] map
  # @return [DirectedAdjacencyGraph]
  def init_graph(map)
    width = map[0].size
    index_of = -> (x, y) { (y * width) + x }

    graph = RGL::DirectedAdjacencyGraph.new
    map.each_with_index.each { |line, li|
      line.each_with_index.each { |_, si|
        i = index_of.call(si, li)
        neighbours = neighbours(si, li, map)

        neighbours.each { |n|
          ni = index_of.call(n[0], n[1])
          graph.add_edge(i, ni)
        }
      }
    }
    graph
  end

  # @param [Array<Integer>] path
  # @param [Array<Array<Integer>>] map
  # @return [Integer]
  def calculate_risk_of_path(path, map)
    width = map[0].size
    from_index = -> (i) { [i % width, i / width] }
    risk = 0
    path.each { |s|
      next if s == 0
      x, y = from_index.call(s)
      risk += map[y][x]
    }
    risk
  end

  # @param [Array<Array<Integer>>] input
  # @param [Boolean] debug
  # @return [Integer]
  def determine_shortest_path_risk(input, debug = false)
    graph = init_graph(input)
    edge_weights = build_edge_weight_map(input)

    path = graph.dijkstra_shortest_path(edge_weights, 0, input.flatten.size - 1)
    print_path(path, input) if debug

    calculate_risk_of_path(path, input)
  end

  # @param [Integer] n
  # @param [Array<Array<Integer>>] input
  # @return [Array<Array<Integer>>]
  def expand(n, input)
    expanded = []

    height = input.size
    width = input[0].size

    (0..n - 1).each { |i|
      (0..n - 1).each { |j|
        add = i + j
        input.each_with_index.each { |y, yi|
          y.each_with_index.each { |v, xi|
            if v + add > 9
              v = v + add - 9
            else
              v += add
            end
            lx = xi + (j * width)
            ly = yi + (i * height)
            if expanded[ly] == nil
              expanded[ly] = []
            end
            expanded[ly][lx] = v
          }
        }
      }
    }
    expanded
  end

  # @param [Array<Array<Integer>>] map
  def print_map(map)
    str = ""
    map.each { |y|
      y.each { |x|
        str << x.to_s
      }
      str << "\n"
    }
    puts str
  end

  # @param [Array<Integer>] path
  # @param [Array<Array<Integer>>] input
  def print_path(path, input)
    width = input[0].size
    str = ""
    path.each { |p|
      str << input[p / width][p % width].to_s
    }
    puts str
  end

  # @param [Array<Array<Integer>>] input
  def part1 (input)
    determine_shortest_path_risk(input)
  end

  def part1_example_expected_result
    40
  end

  def part1_expected_result
    769
  end

  # @param [Array<Array<Integer>>] input
  def part2 (input)
    expanded = expand(5, input)
    determine_shortest_path_risk(expanded)
  end

  def part2_example_expected_result
    315
  end

  def part2_expected_result
    2963
  end

end

Day15.new
