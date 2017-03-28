class Ranges::NodeRange
  attr_reader :nodes

  def initialize
    @nodes ||= []
  end

  def ==(other)
    nodes == other.nodes
  end

  def <<(node)
    @nodes << node
  end

  def merge(other)
    return self unless other.is_a?(Ranges::Range)

    idx = 0
    other_idx = 0
    while idx < nodes.size && other_idx < other.nodes.size
      node = nodes[idx]
      other_node = other.nodes[other_idx]

    end
  end
end
