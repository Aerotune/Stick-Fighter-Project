class Characters::Stick1V2::AnimationStates::WallIdleToJumpRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'wall_idle_to_jump'
    @duration = 0.2
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => false}
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    
    if @character.hit_level_down
      set_state "LandRight", 'start_y' => @character.hit_level_down
    elsif @character.hit_level_right
      if local_time > @duration
        set_in_air_velocity_y time, 3100
        set_state "WallJumpInAirLeft"
      else
        set_in_air_transition_time_y time, @duration
        set_in_air_velocity_y time, 0
      end
    else
      set_in_air_velocity_y time, 3100
      set_state "InAirRight"
    end
  end
end