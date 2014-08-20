class Commands::SetMovementInLine < Command  
  def initialize entity_manager, entity, velocity, start_time, options={}
    @entity_manager = entity_manager
    @entity = entity
    @velocity = velocity
    @start_time = start_time
    @options = options
  end
  
  def do_action
    @prev_movement_component = @entity_manager.get_component @entity, Components::Movement
    position = @entity_manager.get_component @entity, Components::Position
    
    if @prev_movement_component
      @entity_manager.remove_component @entity, @prev_movement_component
      prev_movement = @prev_movement_component.movement
      prev_movement.update(@start_time)
      @start_x ||= @options['start_x'] || prev_movement.x
      @start_y ||= @options['start_y'] || prev_movement.y
      
      case prev_movement
      when MovementInLine
        @start_velocity ||= prev_movement.velocity(@start_time)
      when MovementInAir
        @start_velocity ||= prev_movement.velocity_x(@start_time)
      end
    else
      
      @prev_x  ||= position.x
      @prev_y  ||= position.y
      @start_x ||= @options['start_x'] || @prev_x
      @start_y ||= @options['start_y'] || @prev_y
      start_velocity = 0
      
      
    end
    
    position.next_x = @start_x #if @options['start_x']
    position.next_y = @start_y #if @options['start_y']
    
    @movement = MovementInLine.new \
      'start_time' => @start_time,
      'start_x' => @options['start_x'] || @start_x,
      'start_y' => @options['start_y'] || @start_y,
      'start_velocity' => @start_velocity,
      'terminal_velocity' => @velocity,
      'default_transition_time' => 0.28,
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