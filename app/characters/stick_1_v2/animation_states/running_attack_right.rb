class Characters::Stick1V2::AnimationStates::RunningAttackRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.7
    @sprite_sheet_id = 'dash_kick'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
    @controller_states = ["StandingBalanceBackwardReactivesRight"]
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
    ease_position 'distance' => 190, 'transition_time' => 0.35, 'start_time' => @character.time
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if @has_hit_box
      if local_time > @duration * 0.35
        remove_punch_hit_box
      end
    else
      if local_time > @duration * 0.25
        @has_hit_box = true
        create_punch_hit_box 'right', 'offset_x' => 0, 'offset_y' => -140, 'width' => 80, 'height' => 40, 'strength' => 2.0
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
      if controls.latest_horizontal_move == 'move right'
        set_velocity time, 720
      else
        set_velocity time, 0
      end
    end    
  end
end