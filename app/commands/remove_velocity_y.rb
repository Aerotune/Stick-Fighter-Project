class Commands::RemoveVelocityY < Command
  def initialize entity_manager, entity, time, options
    @entity_manager = entity_manager
    @entity         = entity
    @time           = time
    @options        = options
  end
  
  def do_action
    movement_component = @entity_manager.get_component @entity, Components::Movement
    position = @entity_manager.get_component @entity, Components::Position
    if movement_component
      @prev_movement = movement_component.movement
      
      position.y = @options['start_y'] if @options['start_y']
      position.next_y = @options['start_y'] if @options['start_y']
      
      case @prev_movement
      when MovementInAir
        if @prev_movement.velocity_x(@time).abs > 0.0
          @movement ||= MovementInAir.new \
            'start_time' => @time,
            'start_x' => position.x,
            'start_y' => @options['start_y'] || position.y,
            'start_velocity_y'    => 0,
            'terminal_velocity_y' => 3100,
            'start_velocity_x'    => @prev_movement.velocity_x(@time),
            'terminal_velocity_x' => @prev_movement.terminal_velocity_x,
            'angle' => 0,
            'transition_time_y' => 1.945625
          
          movement_component.movement = @movement
        end
        
      when MovementInLine
        @movement = MovementInLine.new \
          'start_time' => @time,
          'start_x' => @options['start_x'] || position.x,
          'start_y' => @options['start_y'] || position.y,
          'start_velocity' => 0,
          'terminal_velocity' => 0,
          'default_transition_time' => 0.28,
          'angle' => 0
        movement_component.movement = @movement
      when MovementEasePosition
        @movement = MovementEasePosition.new \
          'start_time' => @time,
          'start_x' => @options['start_x'] || position.x,
          'start_y' => @options['start_y'] || position.y,
          'distance' => 0,
          'transition_time' => 1.0
        movement_component.movement = @movement
      end
    end
  end
  
  def undo_action
    movement_component = @entity_manager.get_component @entity, Components::Movement
    movement_component.movement = @prev_movement
  end
end