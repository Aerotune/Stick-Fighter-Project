
class Characters::Stick1V2::AnimationStates::RunRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'run_loop'
    @sprite_options = {'factor_x' => -1, 'fps' => 30}
    @movement_options = {'on_surface' => true, 'velocity' => 720}
    @controller_states = ["StandingAttacksRight", "StandingBalanceNeutralReactivesRight", "CanDuckRight"]
  end
  
  def on_set options
    @run_loop_instance ||= SoundResource.play "run_loop"
  end
  
  def on_unset
    @run_loop_instance.stop if @run_loop_instance
    @run_loop_instance = nil
  end
  
  def control_down control
    case control
    when 'move left' ; set_state "SlideRight", 'next_state' => "RunLeft"
    when 'move up'   ; set_state "JumpRight"
    end
  end
  
  def update_game_logic time 
    return set_state "InAirRight" unless @character.hit_level_down
    
    
    if controls.control_down?('move right')
      set_velocity time, 720
    else
      set_velocity time, 0
      set_state "IdleRight" if velocity_x(time) < 50
    end
    
    set_state "PreBlockRight" if controls.control_down? 'block'
  end
end