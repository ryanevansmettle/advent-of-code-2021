#!/usr/bin/env ruby

require_relative '../lib/util'

class Day04 < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
  end

  def parse_boards (input)
    boards = []
    current_board = []
    (1..input.size - 1).each { |i|
      l = input[i]
      if l == ""
        boards << current_board
        current_board = []
        next
      end

      current_board << l.split.map { |n| n.to_i }
    }
    boards << current_board
    boards.filter { |b| b.size > 0 }
  end

  def exists_on_board(boards, n)
    boards.each { |board|
      board.each.each { |line|
        if line.include? n
          return true
        end
      }
    }
    false
  end

  def is_bingo(boards)
    boards.each { |board|
      board.each.each { |line|
        if line.filter { |l| l != :marked }.count == 0
          return true
        end
      }
      (0..board[0].size - 1).each { |ci|
        column = board.each.map { |l| l[ci] }
        if column.filter { |l| l != :marked }.count == 0
          return true
        end
      }
    }
    false
  end

  def remove_from_board(boards, n)
    boards.each { |board|
      board.each.each { |line|
        if line.include? n
          line[line.index(n)] = :marked
        end
      }
    }
  end

  def count_left_on_board(board)
    sum = 0
    board.each.each { |line|
      sum += line.filter { |n| n != :marked }.sum
    }
    sum
  end

  def get_winning_boards(boards)
    won_boards = []
    boards.each { |board|
      board.each.each { |line|
        if line.filter { |n| n != :marked }.size == 0
          won_boards << board
          break
        end
      }
      (0..board[0].size - 1).each { |ci|
        column = board.each.map { |l| l[ci] }
        if column.filter { |l| l != :marked }.count == 0
          won_boards << board
          break
        end
      }
    }
    won_boards
  end

  def part1 (input)
    numbers = input[0].split(",").map { |n| n.to_i }

    boards = parse_boards(input)
    marked = []
    numbers.each { |n|
      boards.grep(n)
      if exists_on_board(boards, n)
        marked << n
        remove_from_board(boards, n)
      end

      if is_bingo(boards)

        return n * count_left_on_board(get_winning_boards(boards)[0])
      end
    }
  end

  def part1_example_expected_result
    4512
  end

  def part1_expected_result
    82440
  end

  def part2 (input)
    numbers = input[0].split(",").map { |n| n.to_i }

    boards = parse_boards(input)
    marked = []
    numbers.each { |n|
      boards.grep(n)
      if exists_on_board(boards, n)
        marked << n
        remove_from_board(boards, n)
      end

      if is_bingo(boards)
        winning_boards = get_winning_boards(boards)
        winning_boards.each { |w|
          boards.delete(w)
        }
        if boards.size == 0
          return n * count_left_on_board(winning_boards[0])
        end
      end
    }
  end

  def part2_example_expected_result
    1924
  end

  def part2_expected_result
    20774
  end

end

Day04.new
