
class Characters::Stick1V2::AnimationStates::RunRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'run_loop'
    @sprite_options = {'factor_x' => -1, 'fps' => 30}
    @movement_options = {'on_surface' => true, 'velocity' => 720}
  end
  
  def on_set options
    @run_loop_instance ||= SoundResource.play "run_loop"
  end
  
  def on_unset
    @run_loop_instance.stop if @run_loop_instance
    @run_loop_instance = nil
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedBehindRight"
    when 'left' ; set_state "PunchedFrontRight"
    end
  end
  
  def control_down control
    case control
    when 'move left' ; set_state "SlideRight", 'next_state' => "RunLeft"
    when 'move up'   ; set_state "JumpRight"
    when 'attack punch'
      if controls.control_down?('move right') && controls.time_since_control_down('move right') < 0.125
        set_state "RunningAttackRight"
      else
        set_state "PunchRight"
      end
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