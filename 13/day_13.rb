#!/usr/bin/env ruby

require_relative '../lib/util'

class Day13 < Scenario

  # @param [File] input
  def grok_input(input)
    lines = Input.to_lines(input)

    p = :coords
    coords = []
    folds = []
    for line in lines
      if line == ""
        p = :folds
        next
      end
      if p == :coords
        x, y = line.split(",")
        coords << [x.to_i, y.to_i]
      else
        str, i = line.split("=")
        d = str.split(" ").last
        folds << [d, i.to_i]
      end
    end
    [coords, folds]
  end

  def build_map(coords)
    map = []

    max_x = coords.map { |x, _| x }.max
    max_y = coords.map { |_, y| y }.max

    (0..max_y).each { |_|
      row = []
      (0..max_x).each { |_|
        row << "."
      }
      map << row
    }

    coords.each do |x, y|
      map[y][x] = "#"
    end

    map
  end

  # @param [Integer] n
  # @param [Array<Array<String>>] map
  # @return [Array<Array<Array<String>>>]
  def splitx(n, map)
    first = []
    second = []

    map.each_with_index.each { |y, yi|
      first << []
      second << []
      y.each_with_index.each { |_, xi|
        if xi == n
          next
        end
        if xi < n
          first[yi] << y[xi]
        end
        if xi > n
          second[yi] << y[xi]
        end
      }
    }
    [first, second]
  end

  # @param [Integer] n
  # @param [Array<Array<String>>] map
  # @return [Array<Array<Array<String>>>]
  def splity(n, map)
    first = []
    second = []

    map.each_with_index.each { |y, i|
      if i == n
        next
      elsif i < n
        first << y
      else
        second << y
      end
    }
    [first, second]
  end

  # @param [String] dir
  # @param [Integer] n
  # @param [Array<Array<String>>] map
  # @return [Array<Array<Array<String>>>]
  def split(dir, n, map)

    if dir == "y"
      splity(n, map)
    else
      splitx(n, map)
    end

  end

  def fold(dir, n, map, debug = false)
    map1, map2  = split(dir, n, map)

    print_map(map1) if debug
    print_map(map2) if debug

    max_x = map1[0].size - 1
    max_y = map1.size - 1
    map2_size = map2.size

    folded = []
    if dir == "y"

      (0..max_y).each { |y|
        folded[y] = []
        (0..max_x).each { |x|
          c1 = map1[y][x]
          if max_y - y < map2_size
            c2 = map2[max_y - y][x]
          end
          if [c1, c2].include?("#")
            folded[y][x] = "#"
          else
            folded[y][x] = "."
          end
        }
      }
    else
      (0..max_y).each { |y|
        folded[y] = []
        (0..max_x).each { |x|
          c1 = map1[y][x]
          c2 = map2[y][max_x - x]
          if [c1, c2].include?("#")
            folded[y][x] = "#"
          else
            folded[y][x] = "."
          end
        }
      }
    end

    print_map(folded) if debug
    folded
  end

  def print_map(map)
    puts "#{map_to_string(map)}\n\n"
  end

  def map_to_string(map)
    str = ""
    (0..map.size - 1).each { |row|
      map[row].each { |x|
        str << x
      }
      str << "\n"
    }
    str
  end

  def part1 (input)
    coords = input[0]
    folds = input[1]

    map = build_map(coords)

    folded = fold(folds[0][0], folds[0][1], map)

    folded.flatten.filter { |d| d == "#" }.count
  end

  def part1_example_expected_result
    17
  end

  def part1_expected_result
    731
  end

  def part2 (input)
    coords = input[0]
    folds = input[1]

    map = build_map(coords)

    folds.each { |fold|
      map = fold(fold[0], fold[1], map)
    }

    map_to_string(map)
  end

  def part2_example_expected_result
    "#####
#...#
#...#
#...#
#####
.....
.....
"
  end

  def part2_expected_result
    "####.#..#..##..#..#..##..####.#..#..##..
...#.#.#..#..#.#..#.#..#.#....#..#.#..#.
..#..##...#..#.#..#.#....###..#..#.#....
.#...#.#..####.#..#.#....#....#..#.#....
#....#.#..#..#.#..#.#..#.#....#..#.#..#.
####.#..#.#..#..##...##..#.....##...##..
"
  end

end

Day13.new
