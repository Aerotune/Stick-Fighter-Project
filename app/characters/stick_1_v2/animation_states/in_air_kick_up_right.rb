class Characters::Stick1V2::AnimationStates::InAirKickUpRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.4
    @sprite_sheet_id = 'in_air_attack_up'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
    @controller_states = ["InAirReactivesRight"]
  end
  
  def on_set options
    set_in_air_transition_time_y @character.time, 3.0
    @has_hit_box = false
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701
    end
  end
  
  def update_game_logic time 
    local_time = time - @state_set_time
       
    if @character.hit_level_down
      if local_time < @duration * 0.4
        set_state "FallToBackRight", 'start_y' => @character.hit_level_down, 'squelch' => true
      else
        set_state "LandRight", 'start_y' => @character.hit_level_down
      end
    else
      if local_time > @duration
        set_state 'InAirRight'
      elsif local_time > @duration * 0.6 && @has_hit_box
        remove_punch_hit_box
      elsif local_time > @duration * 0.4 && !@has_hit_box
        @has_hit_box = true
        create_punch_hit_box 'up', 'strength' => 2.0, 'width' => 80, 'offset_x' => -40, 'offset_y' => -270, 'height' => 100
      else
        case controls.latest_horizontal_move
        when 'move right'
          set_in_air_velocity_x time, 720
        when 'move left'
          set_in_air_velocity_x time, -720
        else
          set_in_air_velocity_x time, 0
        end
      end
    end
  end
end