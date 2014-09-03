class Characters::Stick1V2::AnimationStates::InAirLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'pre_land'
    @sprite_options = {'factor_x' => 1, 'fps' => 34, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
    @controller_states = ["InAirAttacksLeft", "InAirNeutralLeft", "InAirMovement", "InAirReactivesLeft"]
  end
  
  def on_set options
    @fast_fall = false
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701
      @fast_fall = true
    end
  end
  
  def update_game_logic time    
    if @character.hit_level_down
      set_state "LandLeft", 'start_y' => @character.hit_level_down
    else
      set_in_air_transition_time_y @character.time, 1.945625 if !@fast_fall && !controls.control_down?('move up')
    end
  end
end