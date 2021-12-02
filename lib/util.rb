module Input

  # @return [File]
  def self.read_input
    File.open("input.txt")
  end

  # @return [Array<String>]
  def self.read_lines
    return read_input.each_line
  end

  # @return [Array<Array>]
  def self.read_lines_and_tokenise
    return read_input.each_line.map{|l| Grok.tokenise_spaces(l)}
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
    return tokenise(str,/\s/)
  end
end
