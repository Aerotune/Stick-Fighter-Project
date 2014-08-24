class Characters::Stick1V2::States::FallToStomachRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.7
    @sprite_sheet_id = 'fall_front'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
  end
  
  def control_down control
    local_time = @character.time - @state_set_time
    if local_time > @duration && control.include?('move')
      set_state "StandUpFromStomachRight"
    end
  end
  
  def on_set options
    SoundResource.play 'punched'
    SoundResource.play 'fall'
    ease_position 'distance' => 100, 'transition_time' => @duration*0.5, 'start_time' => @character.time
  end
end