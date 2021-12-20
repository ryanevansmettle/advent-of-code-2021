#!/usr/bin/env ruby

require_relative '../lib/util'

class Day20 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)

    grid = {}

    alg = ""
    read = :alg
    grid_start = nil

    lines.each_with_index.each { |line, i|
      if line == ""
        read = :grid
        grid_start = i + 1
        next
      end
      if read == :alg
        alg << line
      else
        line.chars.each_with_index.each { |c, ci|
          grid[[ci, i - grid_start]] = c
        }
      end

    }

    [alg, grid]
  end

  def surrounding_points(x, y)
    [

      [x - 1, y - 1],
      [x, y - 1],
      [x + 1, y - 1],

      [x - 1, y],
      [x, y],
      [x + 1, y],

      [x - 1, y + 1],
      [x, y + 1],
      [x + 1, y + 1],

    ]
  end

  # @param [Integer] x
  # @param [Integer] y
  # @param [Hash<Array -> String>] grid
  # @param [String] default
  # @return [String]
  def get_neighbours_string(x, y, grid, default)
    str = ""
    for p in surrounding_points(x, y)
      if grid.key?([p[0], p[1]])
        str << grid[[p[0], p[1]]]
      else
        str << default
      end
    end
    str
  end

  def print_image(grid)
    str = "\n\n"
    min_x = grid.keys.map { |x, _| x }.min
    max_x = grid.keys.map { |x, _| x }.max
    min_y = grid.keys.map { |_, y| y }.min
    max_y = grid.keys.map { |_, y| y }.max

    buf = 5
    ((min_y - buf)..(max_y + buf)).each { |y|
      ((min_x - buf)..(max_x + buf)).each { |x|
        if grid.key?([x, y])
          str << grid[[x, y]]
        else
          str << "."
        end
      }
      str << "\n"
    }
    puts str
    str
  end

  def enhance(grid, alg, step)
    output = {}

    buf = 1

    min_x = grid.keys.map { |x, _| x }.min
    max_x = grid.keys.map { |x, _| x }.max
    min_y = grid.keys.map { |_, y| y }.min
    max_y = grid.keys.map { |_, y| y }.max
    ((min_y - buf)..(max_y + buf)).each { |y|
      ((min_x - buf)..(max_x + buf)).each { |x|
        default = step % 2 == 0 && alg[0] == "#" ? "#" : "."

        str = get_neighbours_string(x, y, grid, default)
        val = str.gsub(/\./, "0").gsub(/#/, "1").to_i(2)
        col = alg[val]

        output[[x, y]] = col
      }
    }

    output
  end

  def part1 (input)
    alg, grid = input

    (1..2).each { |i|
      grid = enhance(grid, alg, i)
    }
    grid.values.filter { |v| v == "#" }.count
  end

  def part1_example_expected_result
    35
  end

  def part1_expected_result
    5647
  end

  def part2 (input)
    alg, grid = input

    (1..50).each { |i|
      grid = enhance(grid, alg, i)
    }
    grid.values.filter { |v| v == "#" }.count
  end

  def part2_example_expected_result
    3351
  end

  def part2_expected_result
    15653
  end

end

Day20.new
