class Commands::SetNextState < Command
  def initialize character
    @character = character
  end
  
  def do_action
    return if @run_once
    @run_once = true
    @character.current_animation_state.set_next_state unless @state_set
  end
  
  def undo_action
    
  end
end