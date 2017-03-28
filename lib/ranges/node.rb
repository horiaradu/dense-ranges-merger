class Ranges::Node
  attr_accessor :start, :finish, :label

  def initialize(start:, finish:, label:)
    raise ArgumentError if finish < start
    self.start = start
    self.finish = finish
    self.label = label
  end

  def ==(other)
    other.is_a?(Ranges::Node) &&
      start == other.start &&
      finish == other.finish &&
      label == other.label
  end

  def <=>(other)
    start <=> other.start
  end
end
