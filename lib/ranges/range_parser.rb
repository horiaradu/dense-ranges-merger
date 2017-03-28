class Ranges::RangeParser
  def parse_string(str)
    range = Ranges::NodeRange.new
    current_node = nil
    str.split(' ').each do |node_str|
      label, idx = node_str.split('/')
      idx = idx.to_i
      if current_node && current_node.label == label && current_node.finish == idx - 1
        current_node.finish = idx
      else
        current_node = create_node(range, label, idx)
      end
    end
    range
  end

  def create_node(range, label, idx)
    node = Ranges::Node.new(label: label, start: idx, finish: idx)
    range << node
    node
  end
end