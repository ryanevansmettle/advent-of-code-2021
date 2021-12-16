#!/usr/bin/env ruby

require_relative '../lib/util'

class Day16 < Scenario

  class Packet
    attr_accessor :version
    attr_accessor :type_id

    # @param [String] str
    # @return [Array]
    def self.from_str(str)
      i = 0
      rm = :version
      while i < str.size
        case rm
        when :version
          version = str[i..i + 2].to_i(2)
          rm = :typeid
          i += 3
          next
        when :typeid
          type_id = str[i..i + 2].to_i(2)
          if type_id == 4
            packet = ValuePacket.new
            packet.version = version
            packet.type_id = type_id
            return packet.parse_value(str[i + 3..str.size - 1])
          else
            packet = OperatorPacket.new
            packet.version = version
            packet.type_id = type_id
            return packet.parse_value(str[i + 3..str.size - 1])
          end
        end
      end
    end

    def sum_versions
      raise NotImplementedError
    end
  end

  class ValuePacket < Packet
    attr_accessor :value

    def parse_value(str)
      value_str = ""
      i = 0
      while i < str.size
        is_end = str[i] == "0"
        value_str << str[i + 1..i + 4]
        if is_end
          self.value = value_str.to_i(2)
          remainder = str[i + 5..str.size - 1]
          return [self, remainder]
        end
        i += 5
      end
    end

    def sum_versions
      self.version
    end
  end

  class OperatorPacket < Packet
    attr_accessor :length_type_id
    attr_accessor :sub_packets

    def parse_value(str)
      self.sub_packets = []
      self.length_type_id = str[0].to_i(2)

      if self.length_type_id == 0
        sub_packets_length = str[1..15].to_i(2)
        seen = 0
        until_end = str[16..str.size - 1]
        left = until_end
        until seen == sub_packets_length
          sp, left = Packet.from_str(left)
          diff = until_end.size - left.size
          seen = diff
          self.sub_packets << sp
        end
        left = str[16 + sub_packets_length..str.size]
      else
        num_sub_packets = str[1..11].to_i(2)

        left = str[12..str.size - 1]
        until self.sub_packets.size == num_sub_packets
          sp, left = Packet.from_str(left)
          self.sub_packets << sp
        end
      end

      # return left in string after parsing sub packets
      [self, left]
    end

    def sum_versions
      sum = 0
      for sp in self.sub_packets
        sum += sp.sum_versions
      end
      self.version + sum
    end
  end

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
         .map { |l| l.to_i(16).to_s(2) }
         .map { |bin|
           if bin.size % 4 == 0
             bin
           else
             added = "0" * (4 - (bin.size % 4))
             added + bin
           end
         }
         .map { |l| Packet.from_str(l) }
         .map { |p| p[0] }
  end

  # @param [Packet] packet
  def part1 (packets)
    packets.map { |p| p.sum_versions }
  end

  def part1_example_expected_result
    [6, 9, 14, 16, 12, 23, 31]
  end

  def part1_expected_result
    [991]
  end

  # @param [Packet] packet
  def part2 (packets) end

  def part2_example_expected_result
    nil
  end

  def part2_expected_result
    nil
  end

end

Day16.new
