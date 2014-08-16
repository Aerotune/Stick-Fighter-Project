class Characters::Stick1V2::States::SlideRight < Character::State
  
  def initialize character
    @character = character
    @duration = 0.2
    @sprite_sheet_id = 'slide'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def control_down control
    current_velocity_x = velocity_x(@character.time)
    case control
    when 'move right'
      set_state "RunRight" if current_velocity_x > 0
    when 'move up'
      set_state "JumpRight"
    end
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if controls.control_down?('move left')
      set_velocity time, -720
    end
    
    if local_time >= @duration
      if controls.control_down?('move right')
        set_state "RunRight"
      elsif controls.control_down?('move left')
        set_state "RunLeft"
      else
        set_state "IdleRight"
      end
    end
  end
end