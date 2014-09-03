class Commands::UpdateMovementInAir < Command  
  def initialize entity_manager, entity, start_time, options
    @entity_manager   = entity_manager
    @entity           = entity
    @start_time       = start_time
    @options          = options
  end
  
  def do_action
    @movement_component = @entity_manager.get_component @entity, Components::Movement
    
    movement = @movement_component.movement
    @prev_movement = movement.dup
    
    movement.set_terminal_velocity_x @start_time, @options['terminal_velocity_x'] if @options['terminal_velocity_x']
    movement.set_terminal_velocity_y @start_time, @options['terminal_velocity_y'] if @options['terminal_velocity_y']
    movement.set_transition_time_y @start_time, @options['transition_time_y'] if @options['transition_time_y']
  end
  
  def undo_action
    @movement_component = @entity_manager.get_component @entity, Components::Movement
    @movement_component.movement = @prev_movement
  end
end