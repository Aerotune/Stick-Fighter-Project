class Characters::Stick1V2::AnimationStates::BlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'block'
    @sprite_options = {'factor_x' => -1, 'fps' => 33, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    #set_state "IdleRight" unless controls.control_down? 'block'
  end
  
  def control_down control
    case control
    when 'move right'
      set_state "DashForwardRight"
    when 'move left'
      set_state "DashBackwardRight"
    when 'move up'
      set_state "JumpRight"
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
        set_state "IdleRight"
      end
    end
  end
  
  def on_hit options
    case options['punch_direction']
    when 'left'
      set_state 'BlockRight', 'punched' => true
    when 'right'
      set_state 'PunchedBehindRight'
    end
  end
  
  def on_set options
    if options['punched']
      ease_position 'distance' => -45, 'transition_time' => 0.2, 'start_time' => @character.time
    end
  end
end