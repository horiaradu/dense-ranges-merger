require_relative '../spec_helper'

RSpec.describe Ranges::Serializer do
  let(:subject) { Ranges::Serializer.new }

  it 'parses a sparse range' do
    expected = Ranges::NodeRange.new
    expected << Ranges::Node.new(label: 'a', start: 1, finish: 1)
    expected << Ranges::Node.new(label: 'b', start: 2, finish: 2)
    actual = subject.read('a/1, b/2')

    expect(actual).to eq(expected)
  end

  it 'parses a continuous range' do
    expected = Ranges::NodeRange.new
    expected << Ranges::Node.new(label: 'a', start: 1, finish: 3)
    actual = subject.read('a/1, a/2, a/3')

    expect(actual).to eq(expected)
  end

  it 'detects a change of label' do
    expected = Ranges::NodeRange.new
    expected << Ranges::Node.new(label: 'a', start: 1, finish: 1)
    expected << Ranges::Node.new(label: 'b', start: 2, finish: 2)
    expected << Ranges::Node.new(label: 'a', start: 3, finish: 3)
    actual = subject.read('a/1, b/2, a/3')

    expect(actual).to eq(expected)
  end
end
