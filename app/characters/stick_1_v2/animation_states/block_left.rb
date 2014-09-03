class Characters::Stick1V2::AnimationStates::BlockLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'block'
    @sprite_options = {'factor_x' => 1, 'fps' => 33, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
    @controller_states = ["StandingAttacksLeft"]
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    #set_state "IdleLeft" unless controls.control_down? 'block'
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
  
  def on_hit punch_hit_box
    case punch_hit_box.hit_direction
    when 'right'
      if punch_hit_box.strength > 1.5
        set_state 'PunchedFrontLeft'
      else
        set_state 'BlockLeft', 'punched' => true
      end
    when 'left'
      set_state 'PunchedBehindLeft'
    end
  end
  
  def on_set options
    if options['punched']
      ease_position 'distance' => 45, 'transition_time' => 0.2, 'start_time' => @character.time      
    end
  end
end