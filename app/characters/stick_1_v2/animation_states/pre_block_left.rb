class Characters::Stick1V2::AnimationStates::PreBlockLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.18
    @sprite_sheet_id = 'pre_block'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    local_time = time - @state_set_time
  end
  
  def control_down control
    case control
    when 'move left'
      set_state "DashForwardLeft"
    when 'move right'
      set_state "DashBackwardLeft"
    when 'move up'
      set_state "JumpLeft"
    end
  end
  
  def control_up control
    case control
    when 'block'
      case controls.latest_horizontal_move
      when 'move right'
        set_state "RunRight"
      when 'move left'
        set_state "RunLeft"
      else
        set_state "IdleLeft"
      end
      
    end
  end
  
  def on_hit options
    local_time = @character.time - @state_set_time
    case options['punch_direction']
    when 'right'
      if local_time < @duration * 0.8
        set_state "PunchedFrontLeft"
      else
        set_state "BlockLeft", 'punched' => true
      end
    when 'left'
      set_state "PunchedBehindLeft"
    end
  end
end