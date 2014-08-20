class Characters::Stick1V2::States::IdleRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'idle'
    @sprite_options = {'factor_x' => -1}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    
    @state_triggers = {
      'control_down' => {
        'move right' => "RunRight",
        'move left' => "RunLeft",
        'move up' => "JumpRight",
        'attack punch' => "PunchRight",
        'block' => "PreBlockRight"
      }
    }
  end
  
  def control_down control
    state_name = @state_triggers['control_down'][control]
    set_state state_name if state_name
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedBehindRight"
    when 'left' ; set_state "PunchedFrontRight"
    end
  end
end