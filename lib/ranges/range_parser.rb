class Ranges::RangeParser
  def parse_string(str)
    range = Ranges::NodeRange.new
    str.split(' ').each do |node_str|
      label, idx = node_str.split('/')
      idx = idx.to_i
      range << Ranges::Node.new(label: label, start: idx, finish: idx)
    end
    range
  end
end