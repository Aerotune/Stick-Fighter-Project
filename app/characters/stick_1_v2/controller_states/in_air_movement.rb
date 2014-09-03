class Characters::Stick1V2::ControllerStates::InAirMovement < Character::ControllerState
  
  #def control_down control
  #  case control
  #  when 'move down'
  #    set_in_air_transition_time_y @character.time, 0.86701
  #  end
  #end
  
  def update_game_logic time
    
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