require 'json'
require './state'
require './action'
require './transition'
require './transitions'
require './tikz'
class LTS
  attr_accessor :states, :initial_states, :transitions, :actions

  def parse_json(file)
    f = File.read(file)
    lts = JSON.parse(f)
    @states = states_list(lts["states"])
    @initial_states = init_states_list(lts["initial_states"])
    @actions = actions_list(lts["actions"])
    @transitions = Transitions.new
    @transitions.transition_list lts["transitions"], @actions, @states
  end

  def compose(other_lts, h)
    new_LTS = LTS.new
    new_LTS.states = states_product(other_lts.states)
    new_LTS.initial_states = init_states_product(other_lts.initial_states, new_LTS.states)
    new_LTS.actions = self.actions.merge(other_lts.actions)
    new_LTS.transitions = @transitions.compose(@actions, other_lts.transitions, other_lts.actions, new_LTS.states, h)
    new_LTS
  end

  def to_tex(filename)
    tikz = Tikz.new(@states, @initial_states, @actions, @transitions)
    File.open("#{filename}.tex", 'w') { |file| file.write(tikz.to_tikz) }
  end

  def states_list(states)
    states.inject({}) { |hsh, state_name| hsh[state_name] = State.new(state_name); hsh }
  end

  def states_product(other_states)
    new_states = {}
    @states.each_key do |k1|
      other_states.each_key do |k2|
        new_state_name = "#{k1} #{k2}"
        new_states[new_state_name] =State.new(new_state_name)
      end
    end
    new_states
  end

  def init_states_product(other_states, states)
    new_states = []
    @initial_states.each do |k1|
      other_states.each do |k2|
        new_state_name = "#{k1.name} #{k2.name}"
        new_states << states[new_state_name]
      end
    end
    new_states
  end

  def init_states_list(states)
    states.map { |init_state| @states[init_state] }.compact
  end

  def actions_list(actions)
    actions.inject({}) { |hsh, action_name| hsh[action_name] = Action.new(action_name); hsh }
  end

end