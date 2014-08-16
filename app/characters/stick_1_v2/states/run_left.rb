class Characters::Stick1V2::States::RunLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'run_loop'
    @sprite_options = {'factor_x' => 1, 'fps' => 30}
    @movement_options = {'on_surface' => true, 'velocity' => -720}
  end
  
  def control_down control
    case control
    when 'move right'; set_state "SlideLeft"
    when 'move up'   ; set_state "JumpLeft"      
    end
  end
  
  def update_game_logic time 
    return set_state "InAirLeft" unless @character.hit_level_down
    if controls.control_down?('move left')
      set_velocity time, -720
    else
      set_velocity time, 0
      set_state "IdleLeft" if velocity_x(time) > -50
    end
  end
end