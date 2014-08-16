class Commands::SetMovementInAir < Command  
  def initialize entity_manager, entity, start_velocity_x, start_velocity_y, start_time
    @entity_manager   = entity_manager
    @entity           = entity
    @start_velocity_x = start_velocity_x
    @start_velocity_y = start_velocity_y
    @terminal_velocity_x = 0
    @terminal_velocity_y = 3100
    @start_time       = start_time
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
        @start_velocity_x = prev_movement.velocity(@start_time)
        @terminal_velocity_x = @start_velocity_x
      when MovementInAir
        @start_velocity_x = prev_movement.velocity_x(@start_time)
        @terminal_velocity_x = @start_velocity_x
      end
    else
      position = @entity_manager.get_component @entity, Components::Position
      start_x = position.x
      start_y = position.y
      
      @prev_x = start_x
      @prev_y = start_y
    end
    
    @movement = MovementInAir.new \
      'start_time' => @start_time,
      'start_x' => start_x,
      'start_y' => start_y,
      'start_velocity_x'    => @start_velocity_x,
      'terminal_velocity_x' => @terminal_velocity_x,
      'start_velocity_y'    => @start_velocity_y,
      'terminal_velocity_y' => @terminal_velocity_y,
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