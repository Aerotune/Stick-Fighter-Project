class Characters::Stick1V2::AnimationStates::FallToBackRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.7
    @sprite_sheet_id = 'fall_back'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
  end
  
  def control_down control
    local_time = @character.time - @state_set_time
    if local_time > @duration && control.include?('move')
      set_state "StandUpFromBackRight"
    end
  end
  
  def on_set options
    SoundResource.play 'punched' unless options['squelch']
    SoundResource.play 'fall'
    distance = options['squelch'] ? 0 : -90
    ease_position 'distance' => distance, 'transition_time' => @duration*0.5, 'start_time' => @character.time
  end
end