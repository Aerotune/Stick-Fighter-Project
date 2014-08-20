class Characters::Stick1V2::States::LandLeft < Character::State  
  def initialize character
    @character = character
    @duration = 0.18
    @sprite_sheet_id = 'land'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedFrontLeft"
    when 'left' ; set_state "PunchedBehindLeft"
    end
  end
  
  def control_down control
    local_time = @character.time - @state_set_time
    
    case control
    when 'move up'
      set_state "JumpLeft" if local_time > @duration / 2.6
    end
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    current_velocity_x = velocity_x(time)
    
    if local_time > @duration
      
      case controls.latest_horizontal_move
      when 'move right'
        if current_velocity_x.abs > 60
          set_state "SlideLeft"
        else
          set_state "RunRight"
        end
      when 'move left'
        if current_velocity_x > 0
          set_state "SlideLeft"
        else
          set_state "RunLeft"
        end
      else
        if current_velocity_x > 60
          set_state "SlideLeft"
        elsif current_velocity_x < -60
          set_state "SlideLeft"
        else
          set_state "IdleLeft"
        end
      end
      
    else
      
      case controls.latest_horizontal_move
      when 'move right'
        set_velocity time, 720
      when 'move left'
        set_velocity time, -720
      else
        set_velocity time, 0
      end
      
    end
  end
end