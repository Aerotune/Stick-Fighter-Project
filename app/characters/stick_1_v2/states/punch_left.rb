class Characters::Stick1V2::States::PunchLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.33
    @sprite_sheet_id = 'punch'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def on_hit options
    case options['punch_direction']
    when 'right'; set_state "PunchedFrontLeft"
    when 'left' ; set_state "PunchedBehindLeft"
    end
  end
  
  def control_down control
    case control
    when 'attack punch'
      @next_state = "JabLeft"
    end
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if @can_jab && (local_time < 0.105) && !controls.control_down?('attack punch')
      set_state "JabLeft"
    end
    
    if @has_punched
      remove_punch_hit_box if local_time > @duration * 0.5
    else
      if local_time > @duration * 0.35
        @has_punch = true
        create_punch_hit_box 'left'
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
        if controls.control_down? 'move left'
          @has_moved = true
          ease_position 'distance' => -60, 'transition_time' => 0.3, 'start_time' => @character.time
        elsif controls.control_down? 'move right'
          @has_moved = true
          ease_position 'distance' => 30, 'transition_time' => 0.225, 'start_time' => @character.time
        end
      end
    end
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def on_set options
    @can_jab = options.has_key?('can_jab') ? options['can_jab'] : true
    @next_state = "IdleLeft"
    @has_moved = false
    @has_punched = false
  end
end