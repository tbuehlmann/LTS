require 'json'
require './states'
require './init_states'
require './transitions'
require './actions'
require './tikz'
class LTS
  attr_accessor :states, :initial_states, :transitions, :actions

  def parse_json(file)
    f = File.read(file)
    lts = JSON.parse(f)
    @states = States.new
    @initial_states = InitStates.new
    @transitions = Transitions.new
    @actions = Actions.new
    @states.states_list(lts["states"])
    @initial_states.init_states_list(lts["initial_states"], @states)
    @actions.actions_list(lts["actions"])
    @transitions.transition_list lts["transitions"], @actions, @states
  end

  def compose(other_lts, h)
    new_LTS = LTS.new
    new_LTS.states = States.new
    new_LTS.initial_states = InitStates.new
    new_LTS.actions = Actions.new
    new_LTS.states.compose(@states, other_lts.states)
    new_LTS.initial_states.init_states_product(@initial_states, other_lts.initial_states, new_LTS.states)
    new_LTS.actions = @actions.merge(other_lts.actions)
    new_LTS.transitions = @transitions.compose(@actions, other_lts.transitions, other_lts.actions, new_LTS.states, h)
    new_LTS
  end

  def to_tex(filename)
    tikz = Tikz.new(@states, @initial_states, @actions, @transitions)
    File.open("#{filename}.tex", 'w') { |file| file.write(tikz.to_tikz) }
  end
end