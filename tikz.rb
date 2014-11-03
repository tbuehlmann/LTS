class Tikz
  attr_accessor :states, :initial_states, :actions, :transitions
  def initialize(states, init_states, actions, transitions)
    @states = states
    @initial_states = init_states
    @actions = actions
    @transitions = transitions
    to_tikz
  end

  def to_tikz
    string = tikz_prae
    state_id = 0
    for state in @states
      string += state[1].to_tikz(@initial_states.include?(state[1]), state_id, @states.length)
      state_id += 1
    end
    string += "\\path "
    for transition in @transitions
      string += transition.to_tikz
    end
    string += ";"
    string += tikz_end
    string
  end

  def tikz_prae
    "\\documentclass[tikz]{standalone}

      \\usetikzlibrary{arrows,automata}
      \\begin{document}
      \\begin{tikzpicture}[->,>=stealth',shorten >=1pt,auto,node distance=2.8cm,
                          semithick]
      "
  end

  def tikz_end
    "\\end{tikzpicture}

      \\end{document}"
  end
end