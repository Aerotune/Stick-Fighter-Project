class Characters::Stick1V2::AnimationStates::JumpRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.3
    @sprite_sheet_id = 'jump'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => false, 'start_velocity_y' => -1600}
  end
  
  def on_set options
    SoundResource.play 'jump'
  end
  
  def control_up control
    case control
    when 'move up'
      set_in_air_transition_time_y @character.time, 0.86701
    end
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701
    when 'attack punch'
      case controls.latest_move
      when "move up"
        if controls.time_since_control_down('move up') < 0.125
          set_state "InAirKickUpRight"
        else
          set_state "InAirPunchRight"
        end
      when "move right"
        if controls.time_since_control_down('move right') < 0.125
          set_state "InAirKickRight"
        else
          set_state "InAirPunchRight"
        end
      else
        if controls.control_down?("move down") && controls.time_since_control_down('move down') < 0.125
          set_state "InAirAttackDownRight"
        else
          set_state "InAirPunchRight"
        end
      end
    end
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    
    case controls.latest_horizontal_move
    when 'move right'
      set_in_air_velocity_x time, 720
    when 'move left'
      set_in_air_velocity_x time, -720
    else
      set_in_air_velocity_x time, 0
    end
    
    #if controls.control_down?('move up')
    #  set_in_air_transition_time_y time, 2.83
    #else
    #  set_in_air_transition_time_y time, 0.947
    #end
    
    if local_time >= @duration
      set_state "InAirRight"
    end
  end
end