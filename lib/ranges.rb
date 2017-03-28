require 'ranges/version'
require 'ranges/range_parser'
require 'ranges/node_range'
require 'ranges/node'

module Ranges
  def parse(str)
    RangeParser.new.parse_string(str)
  end
end