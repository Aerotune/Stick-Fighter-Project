class Characters::Stick1V2::AnimationStates::SlammedLeft < Character::State  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'slammed'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def on_set options
    SoundResource.play 'punched'
    SoundResource.play 'fall'
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    
    return set_state "InAirDizzyLeft", 'strength' => 1.0, 'squelch' => true unless @character.hit_level_down
    
    if local_time > @duration && controls.moves.length > 0
      return set_state "StandUpFromBackLeft"
    end
  end
end