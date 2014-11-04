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
    string += @states.to_tikz(@initial_states)
    string += @transitions.to_tikz
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