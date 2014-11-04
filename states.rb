class States < Hash
  attr_accessor :states

  def initialize
    @states = {}
  end

  def states_list(states)
    states.each { |state_name| @states[state_name] = State.new(state_name) }
  end

  def compose(states, other_states)
    states.each_key do |k1|
      other_states.each_key do |k2|
        new_state_name = "#{k1} #{k2}"
        @states[new_state_name] = State.new(new_state_name)
      end
    end
  end

  def [](ind)
    @states[ind]
  end

  def each(&block)
    @states.each(&block)
  end

  def each_key(&block)
    @states.each_key(&block)
  end
  def length
    @states.length
  end

  def to_tikz(initial_states)
    state_id = 0
    string = ""
    for state in @states
      string += state[1].to_tikz(initial_states.include?(state[1]), state_id, @states.length)
      state_id += 1
    end
    string
  end
end