class Ranges::NodeRange
  attr_reader :nodes

  def initialize(hash = {})
    @nodes ||= hash
  end

  def ==(other)
    nodes == other.nodes
  end

  def <<(node)
    @nodes[node.label] ||= []
    nodes_array = @nodes[node.label]
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
      .select { |k| other.nodes.has_key?(k) }
      .each { |key| new_nodes[key] = merge_node_arrays(@nodes[key].clone, other.nodes[key].clone) }

    Ranges::NodeRange.new(new_nodes)
  end

  private

  def merge_node_arrays(nodes, other_nodes)
    result = []
    idx = 0
    other_idx = 0
    while idx < nodes.size && other_idx < other_nodes.size
      node = nodes[idx]
      other_node = other_nodes[other_idx]

      if other_node.start - node.finish > 1
        # [] ()
        result << node
        idx += 1
      elsif node.start - other_node.finish > 1
        # () []
        result << other_node
        other_idx += 1
      elsif node.start < other_node.start
        # [ ( ) ]
        other_nodes.shift
        node.finish = other_node.finish if other_node.finish > node.finish # [ ( ] )
      elsif node.start > other_node.start
        # ( [ ] )
        nodes.shift
        other_node.finish = node.finish if node.finish > other_node.finish # ( [ ) ]
      end
    end

    result.push(*nodes[idx..-1]) if idx < nodes.size
    result.push(*other_nodes[other_idx..-1]) if other_idx < other_nodes.size

    merge_adjacent_nodes!(result)
    result
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
  end
end
