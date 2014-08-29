class Characters::Stick1V2::AnimationStates::StaggerForwardLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.8
    @sprite_sheet_id = 'stagger_forward'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def on_set options
    SoundResource.play 'punched'
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleLeft"
    end
  end
  
  def on_set options
    ease_position 'distance' => -220, 'transition_time' => @duration, 'start_time' => @character.time
  end
end