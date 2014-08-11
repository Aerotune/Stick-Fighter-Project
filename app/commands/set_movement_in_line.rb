class Commands::SetMovementInLine < Command
  def initialize entity_manager, entity, velocity, start_time
    @entity_manager = entity_manager
    @entity = entity
    @velocity = velocity
    @start_time = start_time
  end
  
  def do_action
    @prev_movement_component = @entity_manager.get_component @entity, Components::Movement
    
    if @prev_movement_component
      @entity_manager.remove_component @entity, @prev_movement_component
      prev_movement = @prev_movement_component.movement
      prev_movement.update(@start_time)
      start_x = prev_movement.x
      start_y = prev_movement.y
      
      case prev_movement
      when MovementInLine
        start_velocity = prev_movement.velocity(@start_time)
      when MovementInAir
        start_velocity = 0
      end
    else
      position = @entity_manager.get_component @entity, Components::Position
      start_x = position.x
      start_y = position.y
      start_velocity = 0
      
      @prev_x = start_x
      @prev_y = start_y
    end
    
    @movement = MovementInLine.new \
      'start_time' => @start_time,
      'start_x' => start_x,
      'start_y' => start_y,
      'start_velocity' => start_velocity,
      'terminal_velocity' => @velocity,
      'default_transition_time' => 0.4,
      'angle' => 0
    
    @movement_component = Components::Movement.new(@movement)
    @entity_manager.add_component @entity, @movement_component
  end
  
  def undo_action
    @entity_manager.remove_component @entity, @movement_component
    
    if @prev_movement_component
      @entity_manager.add_component @entity, @prev_movement_component
    end
    
    if @prev_x && @prev_y
      position = @entity_manager.get_component @entity, Components::Position
      position.x = @prev_x
      position.y = @prev_y
    end
  end
end