class Characters::Stick1V2::AnimationStates::StaggerForwardLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.6
    @sprite_sheet_id = 'stagger_forward'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
    @controller_states = ["StandingBalanceForwardReactivesLeft"]
  end
  
  def on_set options
    SoundResource.play 'punched'
    ease_position 'distance' => -220, 'transition_time' => @duration, 'start_time' => @character.time
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleLeft"
    end
  end
end