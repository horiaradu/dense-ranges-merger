class Ranges::Serializer
  def read(str)
    range = Ranges::NodeRange.new
    str.split(', ').each do |node_str|
      label, idx = node_str.split('/')
      idx = idx.to_i
      range << Ranges::Node.new(label: label, start: idx, finish: idx)
    end
    range
  end

  def write(range)
    items = range.nodes.flat_map do |key, nodes_array|
      nodes_array.flat_map do |node|
        node.start.upto(node.finish).map do |idx|
          "#{key}/#{idx}"
        end
      end
    end
    items.join(', ')
  end
end