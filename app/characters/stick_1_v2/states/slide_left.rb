class Characters::Stick1V2::States::SlideLeft < Character::State
  
  def initialize character
    @character = character
    @duration = 0.2
    @sprite_sheet_id = 'slide'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedFrontLeft"
    when 'left' ; set_state "PunchedBehindLeft"
    end
  end
  
  def control_down control
    current_velocity_x = velocity_x(@character.time)
    case control
    when 'move left'
      set_state "RunLeft" if current_velocity_x < 0
    when 'move up'
      set_state "JumpLeft"
    when 'attack punch'
      set_state "PunchLeft"
    end
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if controls.control_down?('move right')
      set_velocity time, 720
    else
      set_velocity time, 0
    end
    
    if local_time >= @duration
      if controls.control_down?('move left')
        set_state "RunLeft"
      elsif controls.control_down?('move right')
        set_state "RunRight"
      else
        set_state @next_state
      end
    end
  end
  
  def on_set options
    @next_state = options['next_state'] || "IdleLeft"
  end
end