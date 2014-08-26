class Commands::RemoveVelocity < Command
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
      
      position.next_x = @options['start_x'] if @options['start_x']
      
      case @prev_movement
      when MovementInAir
        if @prev_movement.velocity_x(@time).abs > 0.0
          @movement ||= MovementInAir.new \
            'start_time' => @time,
            'start_x' => @options['start_x'],
            'start_y' => position.y,
            'start_velocity_x'    => 0,
            'terminal_velocity_x' => 0,
            'start_velocity_y'    => @prev_movement.velocity_y(@time),
            'terminal_velocity_y' => @prev_movement.terminal_velocity_y,
            'angle' => 0
          
          movement_component.movement = @movement
        end
        
      when MovementInLine
        @movement = MovementInLine.new \
          'start_time' => @time,
          'start_x' => @options['start_x'],
          'start_y' => @options['start_y'] || position.y,
          'start_velocity' => 0,
          'terminal_velocity' => 0,
          'default_transition_time' => 0.28,
          'angle' => 0
        movement_component.movement = @movement
      when MovementEasePosition
        @movement = MovementEasePosition.new \
          'start_time' => @time,
          'start_x' => @options['start_x'],
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