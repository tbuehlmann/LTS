require 'json'
require './state'
require './action'
require './transition'
require './tikz'
class LTS
  attr_accessor :states, :initial_states, :transitions, :actions

  def initialize()

  end

  def composite(other_lts, h)
    new_LTS = LTS.new
    new_LTS.states = states_product(other_lts.states)
    new_LTS.initial_states = init_states_product(other_lts.initial_states, new_LTS.states)
    new_LTS.actions = self.actions.merge(other_lts.actions)
    new_LTS.transitions = transitions_comp(other_lts.transitions, other_lts.actions, new_LTS.actions, new_LTS.states, h)
    new_LTS
  end

  def to_tex(filename)
    tikz = Tikz.new(@states, @initial_states, @actions, @transitions)
    File.open("#{filename}.tex", 'w') { |file| file.write(tikz.to_tikz) }
  end

  def parse_json(file)
    f = File.read(file)
    lts = JSON.parse(f)
    @states = states_list(lts["states"])
    @initial_states = init_states_list(lts["initial_states"])
    @actions = actions_list(lts["actions"])
    @transitions = transitions_list(lts["transitions"])
  end

  def transitions_comp(other_trans, other_actions, new_actions, new_States, h)
    h.each { |k, v| other_actions.delete(k) }
    h.each { |k, v| @actions.delete(k) }
    new_trans = []
    h.each do |k, v|
      @transitions.each do |trans1|
        other_trans.each do |trans2|
          if trans2.action.to_s == k && trans1.action.to_s == k
            to_state1 = trans1.to_state
            to_state2 = trans2.to_state
            from_state = "#{trans1.from_state} #{trans2.from_state}"
            to_state = "#{to_state1} #{to_state2}"
            bar =Transition.new(k, new_States[from_state], new_States[to_state])
            new_trans << bar
          end
        end
      end
    end
    @actions.each do |k|
      @transitions.each do |trans1|
        if trans1.action.to_s == k[0]
          other_trans.each do |trans2|
            to_state1 = trans1.to_state
            to_state2 = trans2.from_state
            from_state = "#{trans1.from_state} #{trans2.from_state}"
            to_state = "#{to_state1} #{to_state2}"
            bar =Transition.new(k[0], new_States[from_state], new_States[to_state])
            new_trans << bar
          end
        end
      end
    end
    other_actions.each do |k|
      other_trans.each do |trans2|
        if trans2.action.to_s == k[0]
          @transitions.each do |trans1|
            to_state1 = trans1.from_state
            to_state2 = trans2.to_state
            from_state = "#{trans1.from_state} #{trans2.from_state}"
            to_state = "#{to_state1} #{to_state2}"
            bar = Transition.new(k[0], new_States[from_state], new_States[to_state])
            new_trans << bar
          end
        end
      end
    end
    new_trans
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

  def transitions_list(transitions)
    transitions.map do |transition|
      action = @actions[transition["action"]]
      from_state = @states[transition["from_state"]]
      to_state = @states[transition["to_state"]]
      if action && from_state && to_state
        Transition.new(action, from_state, to_state)
      end
    end.compact #remove nils
  end
end