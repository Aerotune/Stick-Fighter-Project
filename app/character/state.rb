class Character::State
  attr_accessor :state_set_time, :controller_states
  
  def entity_manager
    @character.entity_manager
  end
  
  def entity
    @character.entity
  end
  
  def update_collision_game_logic time
    if @character.hit_level_up
      hit_box = @character.get_component(Components::HitBox)
      @character.time_queue.add time, Commands::RemoveVelocityY.new(entity_manager, entity, time, 'start_y' => @character.hit_level_up+hit_box.height+1)
    else
      if @character.hit_level_right
        @character.time_queue.add time, Commands::RemoveVelocity.new(entity_manager, entity, time, 'start_x' => @character.hit_level_right)
      end
    
      if @character.hit_level_left
        @character.time_queue.add time, Commands::RemoveVelocity.new(entity_manager, entity, time, 'start_x' => @character.hit_level_left)
      end
    end
    
    
  end
  
  #def state_trigger! control_triggers
  #  control_down_triggers = control_triggers['control_down']
  #  controls.moves.reverse_each do |move_control|
  #    if state = control_down_triggers[move_control]
  #      set_state(state)
  #      return
  #    end
  #  end
  #  control_down_triggers.each do |control, state|
  #    if controls.control_down? control
  #      set_state(state)
  #      return
  #    end
  #  end
  #end
  
  def create_set_events time, options={}
    ['@sprite_sheet_id', '@sprite_options', '@movement_options'].each do |variable|
      raise "Missing #{variable} for #{self}" unless instance_variable_get variable
    end
    sprite_settings = @character.class.image_resource[@sprite_sheet_id].merge @sprite_options.merge('start_time' => time)
    @sprite_component = Components::Sprite.new(sprite_settings)
    
    commands = []
    commands << Commands::AddComponent.new(entity_manager, entity, @sprite_component)
    movement_command = Factories::MovementCommand.construct(entity_manager, entity, time, @movement_options.merge(options))
    commands << movement_command if movement_command
    
    set_event = TimeQueue::Event.new time, Commands::MultipleCommands.new(commands)
    
    [set_event]
  end
  
  def create_unset_events time
    unset_command = Commands::RemoveComponent.new(entity_manager, entity, @sprite_component)
    unset_event = TimeQueue::Event.new time, unset_command
    
    [unset_event]
  end
  
  def set_state state_name, options={}
    @character.current_animation_state.on_unset if @character.current_animation_state.respond_to? :on_unset
    time    = @character.time
    command = Commands::SetState.new(@character, state_name, time, options)
    event   = TimeQueue::Event.new time, command
    @character.time_queue.add_events event
  end
  
  def controls
    @character.controls
  end
  
  def update_game_logic time
    
  end
  
  def ease_position options
    @character.time_queue.add @character.time, Commands::SetEaseInLine.new(entity_manager, entity, options)
  end
  
  def velocity_y time
    @character.get_component(Components::Movement).movement.velocity_y(time)
  end
  def velocity_x time
    @character.get_component(Components::Movement).movement.velocity_x(time)
  end
  
  def update_sprite time, options
    sprite = @character.get_component(Components::Sprite)
    needs_update = false
    options.each do |variable, value|
      needs_update = true if value != sprite.instance_variable_get("@#{variable}")
    end
    @character.time_queue.add time, Commands::UpdateSprite.new(entity_manager, entity, options)
  end
  
  def set_velocity time, terminal_velocity_x
    movement = @character.get_component(Components::Movement).movement
    unless movement.terminal_velocity == terminal_velocity_x
      @character.time_queue.add time, Commands::SetMovementInLine.new(entity_manager, entity, terminal_velocity_x, time)
    end
  end
  
  def set_in_air_velocity_x time, terminal_velocity_x
    movement = @character.get_component(Components::Movement).movement
    unless movement.terminal_velocity_x == terminal_velocity_x
      unless (terminal_velocity_x > 0.0 && @character.hit_level_right) || (terminal_velocity_x < 0.0 && @character.hit_level_left)
        @character.time_queue.add time, Commands::UpdateMovementInAir.new(entity_manager, entity, time, 'terminal_velocity_x' => terminal_velocity_x)
      end
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
  
  def set_in_air_transition_time_y time, transition_time_y
    movement = @character.get_component(Components::Movement).movement
    unless movement.transition_time_y == transition_time_y
      @character.time_queue.add time, Commands::UpdateMovementInAir.new(entity_manager, entity, time, 'transition_time_y' => transition_time_y)
    end
  end
  
  def create_punch_hit_box direction, options={}
    return if @punch_hit_box
    @punch_hit_box = Factories::PunchHitBox.construct @character, direction, options
    @character.add_component @punch_hit_box
    #@character.time_queue.add @character.time, Commands::AddComponent(entity_manager, entity, @punch_hit_box)
  end
  
  def remove_punch_hit_box
    if @punch_hit_box
      #@character.time_queue.add @character.time, Commands::RemoveComponent(entity_manager, entity, @punch_hit_box)
      @character.remove_component @punch_hit_box
      @punch_hit_box = nil
    end
  end
end