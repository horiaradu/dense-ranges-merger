require_relative '../spec_helper'

RSpec.describe Ranges::Serializer do
  let(:subject) { Ranges::Serializer.new }

  it 'parses a sparse range' do
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(start: 1, finish: 1)],
      'b' => [Ranges::Node.new(start: 2, finish: 2)]
    )
    actual = subject.read('a/1, b/2')

    expect(actual).to eq(expected)
  end

  it 'parses a continuous range' do
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(start: 1, finish: 3)]
    )
    actual = subject.read('a/1, a/2, a/3')

    expect(actual).to eq(expected)
  end

  it 'parses a two part range' do
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(start: 1, finish: 3),
              Ranges::Node.new(start: 10, finish: 12),
              Ranges::Node.new(start: 20, finish: 20)]
    )
    actual = subject.read('a/1, a/10, a/2, a/11, a/3, a/12, a/20')

    expect(actual).to eq(expected)
  end

  it 'detects a change of label' do
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(start: 1, finish: 1), Ranges::Node.new(start: 3, finish: 3)],
      'b' => [Ranges::Node.new(start: 2, finish: 2)]
    )
    actual = subject.read('a/1, b/2, a/3')

    expect(actual).to eq(expected)
  end

  it 'detects a change of label with a continuation' do
    expected = Ranges::NodeRange.new(
      'a' => [Ranges::Node.new(start: 1, finish: 2)],
      'b' => [Ranges::Node.new(start: 2, finish: 2)]
    )
    actual = subject.read('a/1, b/2, a/2')

    expect(actual).to eq(expected)
  end
end
