class Characters::Stick1V2::States::JabRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.22
    @sprite_sheet_id = 'jab'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => true}
  end
  
  def control_down control
    case control
    when 'attack punch'
      @next_state = ["PunchRight", {'can_jab' => false}]
    end
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time >= @duration
      if @next_state[0].include? "Idle"
        case controls.latest_horizontal_move
        when 'move right'; set_state "RunRight"
        when 'move left';  set_state "RunLeft"
        else
          set_state *@next_state
        end
      else
        set_state *@next_state
      end
    else
      
      if @has_punched
        remove_punch_hit_box if local_time > @duration * 0.5
      else
        if local_time > @duration * 0.35
          @has_punch = true
          create_punch_hit_box 'right', 'offset_x' => 30
        end
      end
      
      unless @has_moved
        if controls.control_down? 'move right'
          @has_moved = true
          ease_position 'distance' => 40, 'transition_time' => 0.2, 'start_time' => @character.time
        elsif controls.control_down? 'move left'
          @has_moved = true
          ease_position 'distance' => -20, 'transition_time' => 0.15, 'start_time' => @character.time
        end
      end
    end
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def on_set options
    SoundResource.play 'punch' unless options['squelch']
    @next_state = ["IdleRight"]
    @has_moved = false
    @has_punched = false
  end
end