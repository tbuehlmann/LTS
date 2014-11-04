require './states'
class InitStates
  attr_accessor :states

  def initialize
    @states = []
  end

  def init_states_product(first_states, other_states, states)
    first_states.each do |k1|
      other_states.each do |k2|
        new_state_name = "#{k1.name} #{k2.name}"
        @states << states[new_state_name]
      end
    end
  end

  def init_states_list(states, all_states)
    states.each { |init_state| @states << all_states[init_state] }
  end

  def [](ind)
    @states[ind]
  end

  def include?(state)
    @states.include?(state)
  end

  def each(&block)
    @states.each(&block)
  end
end