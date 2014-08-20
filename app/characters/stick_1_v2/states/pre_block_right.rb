class Characters::Stick1V2::States::PreBlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.2
    @sprite_sheet_id = 'pre_block'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    local_time = time - @state_set_time
  end
  
  def control_up control
    case control
    when 'block'
      set_state "IdleRight"
    end
  end
  
  def on_hit options
    local_time = @character.time - @state_set_time
    case options['punch_direction']
    when 'left'
      if local_time < @duration * 0.7
        set_state "PunchedFrontRight"
      else
        set_state "BlockRight"
      end
    when 'right'
      set_state "PunchedBehindRight"
    end
  end
end