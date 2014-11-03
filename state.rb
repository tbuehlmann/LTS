class State
  attr_accessor :name

  def initialize(state_name)
    @name = state_name
  end

  def to_tikz(initial, node_id, node_count)
    initial_value = initial ? "initial," : ""
    "\\node[#{initial_value}state] at (#{360/node_count * node_id}:5) (#{name}) {#{name}};\n"
  end

  def to_s
    @name
  end

  def product(other)
    "#{self.name}, #{other.name}"
  end
end