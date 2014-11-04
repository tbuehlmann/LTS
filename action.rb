class Action
  attr_accessor :name

  def initialize(action_name)
    @name = action_name
  end

  def to_tikz
    @name
  end

  def to_s
    @name
  end
end