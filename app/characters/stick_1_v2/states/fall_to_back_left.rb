class Characters::Stick1V2::States::FallToBackLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.7
    @sprite_sheet_id = 'fall_back'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
  end
  
  def control_down control
    local_time = @character.time - @state_set_time
    if local_time > @duration && control.include?('move')
      set_state "StandUpFromBackLeft"
    end
  end
  
  def on_set options
    SoundResource.play 'punched'
    SoundResource.play 'fall'
    ease_position 'distance' => 90, 'transition_time' => @duration*0.5, 'start_time' => @character.time
  end
end