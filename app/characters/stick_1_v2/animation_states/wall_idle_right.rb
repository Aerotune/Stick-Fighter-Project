class Characters::Stick1V2::AnimationStates::WallIdleRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'wall_idle'
    @sprite_options = {'factor_x' => -1, 'fps' => 34}
    @movement_options = {'on_surface' => false}
  end
  
  def control_down control
    case control
    when 'move up'
      set_state "WallIdleToJumpRight"
    end
  end
  
  #def on_set options
  #  set_in_air_transition_time_y @character.time, 3.0 #!!! Causes some replay bugs??
  #end
  
  def update_game_logic time    
    if @character.hit_level_down
      set_state "LandRight", 'start_y' => @character.hit_level_down
    elsif @character.hit_level_right
      if @character.current_animation_state.velocity_y(time) > 1400
        set_state "InAirRight"
      end
    else
      set_state "InAirRight"
    end
  end
end