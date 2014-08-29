class Characters::Stick1V2::AnimationStates::PunchedFrontRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'punched_front'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def on_set options
    SoundResource.play 'punched'
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleRight"
    end
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'
      set_state "PunchedBehindRight"
    when 'left'
      if controls.control_down? 'move left'
        set_state "StaggerBackwardRight"
      else
        set_state "FallToBackRight"
      end
    end
  end
end