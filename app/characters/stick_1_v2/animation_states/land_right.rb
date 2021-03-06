class Characters::Stick1V2::AnimationStates::LandRight < Character::State  
  def initialize character
    @character = character
    @duration = 0.25
    @sprite_sheet_id = 'land'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["StandingBalanceNeutralReactivesRight", "CanDuckRight"]
  end
  
  def on_set options
    SoundResource.play 'land'
    @slide_next_state = "IdleRight"
  end
  
  def control_down control
    local_time = @character.time - @state_set_time
    
    case control
    when 'move up'
      if local_time > @duration * 0.3
        case controls.latest_horizontal_move
        when 'move left'
          set_state "JumpLeft"
        when 'move right'
          set_state "JumpRight"
        else
          set_state "JumpRight"
        end
      end
    when 'move right'
      @slide_next_state = "IdleRight"
    when 'move left'
      @slide_next_state = "IdleLeft"
    end
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    return set_state "PreBlockRight" if controls.control_down? "block"
    
    local_time = time - @state_set_time
    current_velocity_x = velocity_x(time)
    
    if local_time > @duration
      
      case controls.latest_horizontal_move
      when 'move right'
        if current_velocity_x < 0
          set_state "SlideRight", 'next_state' => @slide_next_state
        else
          set_state "RunRight"
        end
      when 'move left'
        if current_velocity_x.abs > 60
          set_state "SlideRight", 'next_state' => @slide_next_state
        else
          set_state "RunLeft"
        end
      else
        if current_velocity_x > 60
          set_state "SlideRight", 'next_state' => @slide_next_state
        elsif current_velocity_x < -60
          set_state "SlideRight", 'next_state' => @slide_next_state
        else
          set_state "IdleRight"
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