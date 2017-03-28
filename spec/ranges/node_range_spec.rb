require_relative '../spec_helper'

RSpec.describe Ranges::NodeRange do
  it 'merges two distinct ranges' do
    first = Ranges::NodeRange.new
    first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
    second = Ranges::NodeRange.new
    second << Ranges::Node.new(label: 'b', start: 1, finish: 3)

    expected = Ranges::NodeRange.new
    expected << Ranges::Node.new(label: 'a', start: 1, finish: 3)
    expected << Ranges::Node.new(label: 'b', start: 1, finish: 3)

    expect(first.merge(second)).to eq(expected)
  end
end
