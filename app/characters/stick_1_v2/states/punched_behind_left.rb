class Characters::Stick1V2::States::PunchedBehindLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'punched_behind'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleLeft"
    end
  end
  
  def on_hit options
    case options['punch_direction']
    when 'left'
      if controls.control_down? 'move left'
        set_state "StaggerForwardLeft"
      else
        set_state "FallToStomachLeft"
      end
    when 'right'
      set_state "PunchedFrontLeft"
    end
  end
end