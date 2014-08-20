class Commands::SetState < Command
  def initialize character, state_name, time, options={}
    @character = character
    @state_name = state_name
    @time = time
    @options = options
  end
  
  def do_action
    raise "state #{@state_name.inspect} doesn't exist for #{@character}" unless @character.states.has_key? @state_name
    
    @prev_state_name = @character.state_name
        
    unless @run_once
      @run_once = true
      
      prev_state = @character.instance_variable_get("@current_state")
      
      if prev_state
        @unset_prev_state_events = prev_state.create_unset_events(@time)
      end
    
      @new_state = @character.states[@state_name]
      @new_state.state_set_time = @time
      
      @set_new_state_events = @new_state.create_set_events(@time, @options)
    
      @character.time_queue.add_events *@unset_prev_state_events, *@set_new_state_events
    end
    
    @character.instance_variable_set("@current_state", @new_state)
    if @character.stage.live?
      @new_state.on_set @options if @new_state.respond_to? :on_set
    end
    
  end
  
  def undo_action
    @character.instance_variable_set("@current_state", @prev_state_name)
    #@set_new_state_command.undo!
    #@unset_prev_state_command.undo! if @unset_prev_state_command
  end
end