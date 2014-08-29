class Characters::Stick1V2::AnimationStates::DashBackwardLeft < Character::State  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'roll_backward'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration}
    @movement_options = {'on_surface' => true}
  end
  
  def on_set options
    SoundResource.play 'jump', 0.8, 0.5 unless options['squelch']
    @next_state = nil
    ease_position 'distance' => 300, 'transition_time' => @duration, 'start_time' => @character.time
  end
  
  def on_unset
    @next_state = nil
  end
  
  def control_down control
    case control
    when 'attack punch'
      @next_state = ["PunchLeft"]
    when 'move up'
      @next_state = ["JumpLeft"]
    end
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    return set_state "InAirLeft" unless @character.hit_level_down if local_time > @duration/2.0
    if local_time > @duration
      case controls.latest_horizontal_move
      when 'move left'
        @next_state ||= ['RunLeft']
      when 'move right'
        @next_state ||= ['RunRight']
      else
        @next_state ||= ['BlockLeft', 'punched' => false] if controls.control_down? 'block'
      end
      
      @next_state ||= ["IdleLeft"]
      set_state *@next_state
    end
  end
end