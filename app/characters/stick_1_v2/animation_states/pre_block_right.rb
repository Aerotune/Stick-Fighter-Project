class Characters::Stick1V2::AnimationStates::PreBlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.18
    @sprite_sheet_id = 'pre_block'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["StandingAttacksRight"]
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    local_time = time - @state_set_time
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
  
  def on_hit punch_hit_box
    local_time = @character.time - @state_set_time
    case punch_hit_box.hit_direction
    when 'left'
      if local_time < @duration * 0.8
        set_state "PunchedFrontRight"
      else
        if punch_hit_box.strength > 1.5
          set_state "PunchedFrontRight"
        else
          set_state "BlockRight", 'punched' => true
        end
      end
    when 'right'
      set_state "PunchedBehindRight"
    end
  end
end