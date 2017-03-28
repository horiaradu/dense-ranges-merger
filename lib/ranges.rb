require 'ranges/version'
require 'ranges/serializer'
require 'ranges/node_range'
require 'ranges/node'

module Ranges
  def parse(str)
    Serializer.new.read(str)
  end
end
