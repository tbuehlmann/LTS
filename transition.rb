class Transition
  attr_accessor :from_state, :to_state, :action
  def initialize(action, from_state, to_state)
    @action = action
    @from_state = from_state
    @to_state = to_state
  end

  def to_s
    "#{@action} : #{@from_state} => #{to_state}"
  end

  def to_tikz
    loop = @from_state == @to_state ? "loop" : "bend"
    "(#{from_state}) edge [#{loop} left] node {#{action}} (#{to_state}) \n"
  end
end