class Commands::SetEaseInLine < Command  
  def initialize entity_manager, entity, options={}
    @entity_manager = entity_manager
    @entity = entity
    @start_time = options['start_time']
    @options = options
  end
  
  def do_action
    @prev_movement_component = @entity_manager.get_component @entity, Components::Movement
    position = @entity_manager.get_component @entity, Components::Position
    
    if @prev_movement_component
      @entity_manager.remove_component @entity, @prev_movement_component
      prev_movement = @prev_movement_component.movement
      prev_movement.update(@start_time)
      start_x = prev_movement.x
      start_y = prev_movement.y
    else
      
      start_x = position.x
      start_y = position.y
      
      @prev_x = start_x
      @prev_y = start_y
    end
    
    position.next_x = @options['start_x'] if @options['start_x']
    position.next_y = @options['start_y'] if @options['start_y']
    
    @movement = MovementEasePosition.new \
      'start_time' => @start_time,
      'start_x' => @options['start_x'] || start_x,
      'start_y' => @options['start_y'] || start_y,
      'distance' => @options['distance'],
      'transition_time' => @options['transition_time']
    
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