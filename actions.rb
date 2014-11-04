require './action'
class Actions
  attr_accessor :actions

  def initialize
    @actions = {}
  end

  def actions_list(actions)
    actions.each { |action_name| @actions[action_name] = Action.new(action_name) }
  end

  def [](ind)
    @actions[ind]
  end

  def each(&block)
    @actions.each(&block)
  end

  def each_key(&block)
    @actions.each_key(&block)
  end

  def length
    @actions.length
  end

  def merge(other_actions)
    @actions.merge(other_actions.actions)
  end

  def delete(ind)
    @actions.delete(ind)
  end
end