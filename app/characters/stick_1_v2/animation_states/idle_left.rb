class Characters::Stick1V2::AnimationStates::IdleLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'idle'
    @sprite_options = {'factor_x' => 1}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["StandingAttacksLeft", "StandingBalanceNeutralReactivesLeft", "CanDuckLeft"]
    
    @state_triggers = {
      'control_down' => {
        'move right' => "RunRight",
        'move left' => "RunLeft",
        'move up' => "JumpLeft",
        'block' => "PreBlockLeft"
      }
    }
  end
  
  def control_down control
    state_name = @state_triggers['control_down'][control]
    set_state state_name if state_name
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    set_state "PreBlockLeft" if controls.control_down? "block"
  end
end