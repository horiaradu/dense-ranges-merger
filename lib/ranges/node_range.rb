class Ranges::NodeRange
  attr_reader :nodes

  def initialize(hash = {})
    @nodes ||= hash
  end

  def ==(other)
    nodes == other.nodes
  end

  def <<(label:, node:)
    @nodes[label] ||= []
    nodes_array = @nodes[label]
    idx = nodes_array.size - 1
    idx -= 1 until idx == -1 || nodes_array[idx].finish == node.start - 1
    if idx == -1
      nodes_array << node
    else
      nodes_array[idx].finish = node.start
    end
  end

  def merge(other)
    return self unless other.is_a?(Ranges::NodeRange)

    new_nodes = other.nodes.merge(@nodes)
    @nodes
      .keys
      .select { |k| other.nodes.key?(k) }
      .each { |key| new_nodes[key] = merge_node_arrays(@nodes[key].clone, other.nodes[key].clone) }

    Ranges::NodeRange.new(new_nodes)
  end

  private

  def merge_node_arrays(nodes, other_nodes)
    result = []
    until nodes.empty? || other_nodes.empty?
      result << if nodes[0].start < other_nodes[0].start
                  merge_heads_and_shift!(nodes, other_nodes)
                else
                  merge_heads_and_shift!(other_nodes, nodes)
                end
    end

    result.push(*nodes) unless nodes.empty?
    result.push(*other_nodes) unless other_nodes.empty?

    merge_adjacent_nodes!(result)
  end

  def merge_heads_and_shift!(nodes, other_nodes)
    node = nodes[0]
    other_node = other_nodes[0]

    if other_node.start - node.finish > 1
      # [] ()
      nodes.shift
    else
      # [ ( ) ]
      other_nodes.shift
      node.finish = other_node.finish if other_node.finish > node.finish # [ ( ] )
    end
    node
  end

  def merge_adjacent_nodes!(nodes)
    idx = 0
    while idx < nodes.size - 1
      if nodes[idx].finish >= nodes[idx + 1].start - 1
        nodes[idx].finish = nodes[idx + 1].finish
        nodes.delete_at(idx + 1)
      else
        idx += 1
      end
    end
    nodes
  end
end
