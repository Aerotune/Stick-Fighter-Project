class Characters::Stick1V2::AnimationStates::UppercutRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.6
    @sprite_sheet_id = 'uppercut'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
    @controller_states = ["StandingBalanceNeutralReactivesLeft"]
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if @has_punched
      remove_punch_hit_box if local_time > @duration * 0.4
    else
      if local_time > @duration * 0.25
        @has_punched = true
        create_punch_hit_box 'up', 'strength' => 1.0, 'offset_x' => -40, 'offset_y' => -220, 'width' => 120, 'height' => 220
      end
    end
    
    if local_time >= @duration
      if @next_state.include? "Idle"
        case controls.latest_horizontal_move
        when 'move right'; set_state "RunRight"
        when 'move left';  set_state "RunLeft"
        else
          set_state @next_state
        end
      else
        set_state @next_state
      end
    else
      unless @has_moved
        case controls.latest_horizontal_move
        when 'move left'
          @has_moved = true
          ease_position 'distance' => -170, 'transition_time' => 0.2, 'start_time' => @character.time
        when 'move right'
          @has_moved = true
          ease_position 'distance' => 170, 'transition_time' => 0.2, 'start_time' => @character.time
        end
      end
    end
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def on_set options
    SoundResource.play 'punch' unless options['squelch']
    @next_state = "IdleRight"
    @has_moved = false
    @has_punched = false
  end
end