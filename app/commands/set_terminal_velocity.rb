class Commands::SetTerminalVelocity < Command
  def initialize entity_manager, entity, time, options
    @entity_manager = entity_manager
    @entity         = entity
    @time           = time
    @options        = options
  end
  
  def do_action
    movement_component = @entity_manager.get_component @entity, Components::Movement
    if movement_component
      @prev_movement = movement_component.movement
      movement = @prev_movement.dup
      movement_component.movement = movement
      
      case movement
      when MovementInAir
        movement.set_terminal_velocity_x @time, @options['velocity_x']
      when MovementInLine
        movement.set_terminal_velocity @time, @options['velocity_x']
      end
    end
  end
  
  def undo_action
    movement_component = @entity_manager.get_component @entity, Components::Movement
    movement_component.movement = @prev_movement
  end
end