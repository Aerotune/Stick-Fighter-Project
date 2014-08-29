class Characters::Stick1V2::AnimationStates::StandUpFromStomachLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.5
    @sprite_sheet_id = 'stand_up_from_stomach'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleLeft"
    end
  end
end