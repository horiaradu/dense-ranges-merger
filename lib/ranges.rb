require 'ranges/version'
require 'ranges/serializer'
require 'ranges/node_range'
require 'ranges/node'

module Ranges
  def parse(str)
    Serializer.new.read(str)
  end

  def write(range)
    Serializer.new.write(range)
  end
end
