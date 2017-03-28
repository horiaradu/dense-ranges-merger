require_relative '../spec_helper'

RSpec.describe Ranges::NodeRange do
  describe 'building a range' do
    it 'builds a sparse range' do
      actual = Ranges::NodeRange.new
      actual << Ranges::Node.new(label: 'a', start: 1, finish: 1)
      actual << Ranges::Node.new(label: 'b', start: 2, finish: 2)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 1)],
        'b' => [Ranges::Node.new(label: 'b', start: 2, finish: 2)]
      )

      expect(actual).to eq(expected)
    end

    it 'builds a continuous range' do
      actual = Ranges::NodeRange.new
      actual << Ranges::Node.new(label: 'a', start: 1, finish: 1)
      actual << Ranges::Node.new(label: 'a', start: 2, finish: 2)
      actual << Ranges::Node.new(label: 'a', start: 3, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 3)]
      )

      expect(actual).to eq(expected)
    end

    it 'detects a change of label' do
      actual = Ranges::NodeRange.new
      actual << Ranges::Node.new(label: 'a', start: 1, finish: 1)
      actual << Ranges::Node.new(label: 'b', start: 2, finish: 2)
      actual << Ranges::Node.new(label: 'a', start: 3, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 1),
                Ranges::Node.new(label: 'a', start: 3, finish: 3)],
        'b' => [Ranges::Node.new(label: 'b', start: 2, finish: 2)]
      )

      expect(actual).to eq(expected)
    end
  end

  describe 'merging two ranges' do
    it 'merges two distinct ranges' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'b', start: 1, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 3)],
        'b' => [Ranges::Node.new(label: 'b', start: 1, finish: 3)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two non overlapping ranges with the same label: [] ()' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 10, finish: 30)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 3),
                Ranges::Node.new(label: 'a', start: 10, finish: 30)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two overlapping ranges with the same label: [ ( ] )' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 2, finish: 4)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 4)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two overlapping ranges with the same label: [ () ]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 4)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 2, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 4)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two non overlapping ranges with the same label - reversed: () []' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 10, finish: 30)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 1, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 3),
                Ranges::Node.new(label: 'a', start: 10, finish: 30)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two overlapping ranges with the same label - reversed: ( [ ) ]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 2, finish: 4)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 1, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 4)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two overlapping ranges with the same label - reversed: [ () ]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 2, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 1, finish: 4)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 4)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two touching ranges with the same label: ()[]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 3, finish: 6)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 1, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 6)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two adjacent ranges with the same label: ()[]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 4, finish: 6)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 1, finish: 3)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 6)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two touching ranges with the same label - reversed : ()[]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 3, finish: 6)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 6)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges two adjacent ranges with the same label - reversed: ()[]' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 4, finish: 6)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 6)]
      )

      expect(first.merge(second)).to eq(expected)
    end
  end

  describe 'merging multiple ranges' do
    it 'merges three overlapping ranges with the same label' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      first << Ranges::Node.new(label: 'a', start: 5, finish: 10)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 2, finish: 9)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 10)]
      )

      expect(first.merge(second)).to eq(expected)
    end

    it 'merges multiple overlapping ranges with the same label' do
      first = Ranges::NodeRange.new
      first << Ranges::Node.new(label: 'a', start: 1, finish: 3)
      first << Ranges::Node.new(label: 'a', start: 8, finish: 10)
      first << Ranges::Node.new(label: 'a', start: 20, finish: 30)
      second = Ranges::NodeRange.new
      second << Ranges::Node.new(label: 'a', start: 2, finish: 9)
      second << Ranges::Node.new(label: 'a', start: 12, finish: 18)

      expected = Ranges::NodeRange.new(
        'a' => [Ranges::Node.new(label: 'a', start: 1, finish: 10),
                Ranges::Node.new(label: 'a', start: 12, finish: 18),
                Ranges::Node.new(label: 'a', start: 20, finish: 30)]
      )

      expect(first.merge(second)).to eq(expected)
    end
  end
end
