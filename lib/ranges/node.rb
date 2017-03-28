class Ranges::Node
  attr_accessor :start, :finish

  def initialize(start:, finish:)
    raise ArgumentError if finish < start
    @start = start
    @finish = finish
  end

  def ==(other)
    other.is_a?(Ranges::Node) &&
      start == other.start &&
      finish == other.finish
  end

  def <=>(other)
    start <=> other.start
  end
end
