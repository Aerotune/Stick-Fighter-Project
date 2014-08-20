class Characters::Stick1V2::States::BlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'block'
    @sprite_options = {'factor_x' => -1, 'fps' => 33, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    set_state "IdleRight" unless controls.control_down? 'block'
  end
  def on_hit options
    case options['punch_direction']
    when 'left'
      set_state 'BlockRight'
    when 'right'
      set_state 'PunchedBehindRight'
    end
  end
  
  def on_set options
    ease_position 'distance' => -45, 'transition_time' => 0.2, 'start_time' => @character.time
  end
end