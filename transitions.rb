class Transitions
  attr_reader :transitions

  def initialize
    @transitions = []
  end
  def add_transition(transition)
    @transitions << transition
  end

  def include?(transition)
    @transitions.include?(transition)
  end

  def to_tikz
    string = "\\path "
    for transition in @transitions
      string += transition.to_tikz
    end
    string += ";"
  end

  def transition_list(transitions, actions, states)
    transitions.each do |transition|
      action = actions[transition["action"]]
      from_state = states[transition["from_state"]]
      to_state = states[transition["to_state"]]
      if action && from_state && to_state
        add_transition(Transition.new(action, from_state, to_state))
      end
    end
  end

  def compose(actions, other_trans, other_actions, new_States, h)
    h.each { |k, v| other_actions.delete(k) }
    h.each { |k, v| actions.delete(k) }
    new_trans = Transitions.new
    h.each do |k, v|
      @transitions.each do |trans1|
        other_trans.each do |trans2|
          if trans2.action.to_s == k && trans1.action.to_s == k
            to_state1 = trans1.to_state
            to_state2 = trans2.to_state
            from_state = "#{trans1.from_state} #{trans2.from_state}"
            to_state = "#{to_state1} #{to_state2}"
            new_trans.add_transition Transition.new(k, new_States[from_state], new_States[to_state])
          end
        end
      end
    end
    actions.each do |k|
      @transitions.each do |trans1|
        if trans1.action.to_s == k[0]
          other_trans.each do |trans2|
            to_state1 = trans1.to_state
            to_state2 = trans2.from_state
            from_state = "#{trans1.from_state} #{trans2.from_state}"
            to_state = "#{to_state1} #{to_state2}"
            new_trans.add_transition Transition.new(k[0], new_States[from_state], new_States[to_state])
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
            new_trans.add_transition Transition.new(k[0], new_States[from_state], new_States[to_state])
          end
        end
      end
    end
    new_trans
  end

  def each(&block)
    @transitions.each(&block)
  end
end