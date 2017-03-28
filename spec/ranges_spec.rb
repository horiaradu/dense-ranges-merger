require 'spec_helper'

RSpec.describe Ranges do
  include Ranges
  it 'has a version number' do
    expect(Ranges::VERSION).not_to be nil
  end

  it 'merges the assignment correctly' do
    first = parse('a/1, a/2, a/3, a/4, a/128, a/129, b/65, b/66, c/1, c/10, c/42')
    second = parse('a/1, a/2, a/3, a/4, a/5, a/126, a/127, b/100, c/2, c/3, d/1')
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 5),
              Ranges::Node.new(label: 'a', start: 126, finish: 129)],
      'b' => [Ranges::Node.new(label: 'b', start: 65, finish: 66),
              Ranges::Node.new(label: 'b', start: 100, finish: 100)],
      'c' => [Ranges::Node.new(label: 'c', start: 1, finish: 3),
              Ranges::Node.new(label: 'c', start: 10, finish: 10),
              Ranges::Node.new(label: 'c', start: 42, finish: 42)],
      'd' => [Ranges::Node.new(label: 'd', start: 1, finish: 1)]
    )
    actual = first.merge(second)
    expect(actual).to eq(expected)
    expect(Ranges::Serializer.new.write(actual)).to eq('a/1, a/2, a/3, a/4, a/5, a/126, a/127, a/128, a/129, b/65, ' \
    'b/66, b/100, c/1, c/2, c/3, c/10, c/42, d/1')
  end
end
