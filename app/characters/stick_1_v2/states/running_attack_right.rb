class Characters::Stick1V2::States::RunningAttackRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.45
    @sprite_sheet_id = 'dash_kick'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedBehindRight"
    when 'left' ; set_state "PunchedFrontRight"
    end
  end
  
  def control_down control
    case control
    when 'attack punch'
      @attack_after = true
    end
  end
  
  def on_set options
    SoundResource.play 'punch' unless options['squelch']
    @attack_after = false
    @has_hit_box  = false
    ease_position 'distance' => 200, 'transition_time' => 0.4, 'start_time' => @character.time
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if @has_hit_box
      if local_time > @duration * 0.55
        remove_punch_hit_box
      end
    else
      if local_time > @duration * 0.4
        @has_hit_box = true
        create_punch_hit_box 'right', 'offset_x' => 10, 'width' => 100
      end
    end
    
    if local_time > @duration
      if @attack_after
        set_state "PunchRight"
      else
        case controls.latest_horizontal_move
        when 'move right'
          set_state "RunRight"
        when 'move left'
          set_state "RunLeft"
        else
          set_state "IdleRight"
        end
      end
    elsif local_time > 0.35
      if controls.control_down?('move right')
        set_velocity time, 720
      end
    end    
  end
end