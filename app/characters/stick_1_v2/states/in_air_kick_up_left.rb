class Characters::Stick1V2::States::InAirKickUpLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'in_air_attack_up'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701
    end
  end
  
  def update_game_logic time 
    local_time = time - @state_set_time
       
    if @character.hit_level_down
      set_state "LandLeft", 'start_y' => @character.hit_level_down
    else
      if local_time > @duration
        set_state 'InAirLeft'
      else
        case controls.latest_horizontal_move
        when 'move right'
          set_in_air_velocity_x time, 720
        when 'move left'
          set_in_air_velocity_x time, -720
        else
          set_in_air_velocity_x time, 0
        end
      end
    end
  end
end