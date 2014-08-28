class Characters::Stick1V2::States::KnockupRight < Character::State  
  def initialize character
    @character = character
    @duration = 0.7
    @sprite_sheet_id = 'knockup'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    #@movement_options = {'on_surface' => false, 'start_velocity_y' => -1600}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def on_set options
    SoundResource.play 'jump'
    ease_position 'distance' => -350, 'transition_time' => @duration, 'start_time' => @character.time
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    
    if local_time > @duration * 0.45
      return set_state "InAirRight" unless @character.hit_level_down
    end
  end
end