#!/usr/bin/env ruby

require_relative '../lib/util'

class Packet
  attr_reader :version
  attr_reader :type_id

  def initialize(version, type_id)
    @version = version
    @type_id = type_id
  end

  # Parses the next packet (and any sub-packets) in the given bitstring.
  # Returns the bitstring remaining after the packet definition.
  # @param [String] str
  # @return [Array[Packet|Integer]]
  def self.from_str(str)
    version = str[0..2].to_i(2)
    type_id = str[3..5].to_i(2)

    if type_id == 4
      packet = ValuePacket.new(version, type_id)
    else
      packet = OperatorPacket.new(version, type_id)
    end

    return packet.parse_value(str[6..str.size - 1])
  end

  def sum_versions
    raise NotImplementedError
  end

  def compute_value
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
        left = str[i + 5..str.size - 1]
        return [self, left]
      end
      i += 5
    end
  end

  def sum_versions
    self.version
  end

  def compute_value
    self.value
  end
end

class OperatorPacket < Packet
  attr_accessor :length_type_id
  attr_accessor :sub_packets

  def parse_value(str)
    self.sub_packets = []
    self.length_type_id = str[0].to_i(2)

    # This is messy.  Parse each chunk of the remaining string until we've covered everything in the sub_packets_length range.
    # Hold onto the remaining string ('left') which may contain sibling packets.
    if self.length_type_id == 0
      sub_packets_length = str[1..15].to_i(2)
      seen = 0
      until_end = str[16..str.size - 1]
      left = until_end
      until seen == sub_packets_length
        sp, left = Packet.from_str(left)
        seen = until_end.size - left.size
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

    [self, left]
  end

  # @return [Integer]
  def sum_versions
    self.version + self.sub_packets.map { |sp| sp.sum_versions }.sum
  end

  # @return [Integer]
  def compute_value
    case self.type_id
    when 0
      self.sub_packets.map(&:compute_value).sum
    when 1
      self.sub_packets.map(&:compute_value).reduce(:*)
    when 2
      self.sub_packets.map(&:compute_value).min
    when 3
      self.sub_packets.map(&:compute_value).max
    when 5
      self.sub_packets[0].compute_value > self.sub_packets[1].compute_value ? 1 : 0
    when 6
      self.sub_packets[0].compute_value < self.sub_packets[1].compute_value ? 1 : 0
    when 7
      self.sub_packets[0].compute_value == self.sub_packets[1].compute_value ? 1 : 0
    else
      raise "Shit"
    end
  end
end

class Day16 < Scenario

  # @param [String] bitstring
  # @return [String]
  def pad_bitstring(bitstring)
    if bitstring.size % 4 == 0
      bitstring
    else
      padding = "0" * (4 - (bitstring.size % 4))
      padding + bitstring
    end
  end

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
         .map { |l| l.to_i(16).to_s(2) }
         .map(&method(:pad_bitstring))
         .map { |l| Packet.from_str(l)[0] }
  end

  # @param [Array<Packet>] packets
  def part1 (packets)
    packets.map(&:sum_versions)
  end

  def part1_example_expected_result
    [
      6, 9, 14, 16, 12, 23, 31,
      14, 15, 11, 13, 19, 16, 20
    ]
  end

  def part1_expected_result
    [991]
  end

  # @param [Array<Packet>] packets
  def part2 (packets)
    packets.map(&:compute_value)
  end

  def part2_example_expected_result
    [
      2021, 1, 3, 15, 46, 46, 54,
      3, 7, 9, 1, 0, 0, 1
    ]
  end

  def part2_expected_result
    [1264485568252]
  end

end

Day16.new
