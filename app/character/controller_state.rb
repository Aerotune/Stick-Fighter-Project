class Character::ControllerState
  attr_accessor :state_set_time
  
  def initialize character
    @character = character
  end
  
  def entity_manager
    @character.entity_manager
  end
  
  def entity
    @character.entity
  end
  
  def controls
    @character.controls
  end

  def set_state state_name, options={}
    @character.current_animation_state.on_unset if @character.current_animation_state.respond_to? :on_unset
    time    = @character.time
    command = Commands::SetState.new(@character, state_name, time, options)
    event   = TimeQueue::Event.new time, command
    @character.time_queue.add_events event
  end
  
  def update_game_logic time
    
  end
  
  def set_in_air_velocity_x time, terminal_velocity_x
    movement = @character.get_component(Components::Movement).movement
    unless movement.terminal_velocity_x == terminal_velocity_x
      unless (terminal_velocity_x > 0.0 && @character.hit_level_right) || (terminal_velocity_x < 0.0 && @character.hit_level_left)
        @character.time_queue.add time, Commands::UpdateMovementInAir.new(entity_manager, entity, time, 'terminal_velocity_x' => terminal_velocity_x)
      end
    end
  end
  
  def set_in_air_transition_time_y time, transition_time_y
    movement = @character.get_component(Components::Movement).movement
    unless movement.transition_time_y == transition_time_y
      @character.time_queue.add time, Commands::UpdateMovementInAir.new(entity_manager, entity, time, 'transition_time_y' => transition_time_y)
    end
  end
  
  def set_in_air_velocity_y time, terminal_velocity_y
    movement = @character.get_component(Components::Movement).movement
    unless movement.terminal_velocity_y == terminal_velocity_y
      #unless (terminal_velocity_y > 0.0 && @character.hit_level_right) || (terminal_velocity_x < 0.0 && @character.hit_level_left)
        @character.time_queue.add time, Commands::UpdateMovementInAir.new(entity_manager, entity, time, 'terminal_velocity_y' => terminal_velocity_y)
        #end
    end
  end
end