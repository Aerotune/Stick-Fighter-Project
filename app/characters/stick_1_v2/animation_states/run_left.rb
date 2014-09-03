class Characters::Stick1V2::AnimationStates::RunLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'run_loop'
    @sprite_options = {'factor_x' => 1, 'fps' => 30}
    @movement_options = {'on_surface' => true, 'velocity' => -720}
    @controller_states = ["StandingAttacksLeft", "StandingBalanceNeutralReactivesLeft", "CanDuckLeft"]
  end
  
  def on_set options
    @run_loop_instance ||= SoundResource.play("run_loop")
  end
  
  def on_unset
    @run_loop_instance.stop if @run_loop_instance
    @run_loop_instance = nil
  end
  
  def control_down control
    case control
    when 'move right'; set_state "SlideLeft", 'next_state' => "RunRight"
    when 'move up'   ; set_state "JumpLeft" 
    end
  end
  
  def update_game_logic time 
    return set_state "InAirLeft" unless @character.hit_level_down
    
    
    if controls.control_down?('move left')
      set_velocity time, -720
    else
      set_velocity time, 0
      set_state "IdleLeft" if velocity_x(time) > -50
    end
    
    set_state "PreBlockLeft" if controls.control_down? 'block'
  end
end