class Characters::Stick1V2::AnimationStates::InAirKickRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.45
    @sprite_sheet_id = 'in_air_kick'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
    @controller_states = ["InAirReactivesRight"]
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701 unless @landed
    end
  end
  
  def on_set options
    #set_in_air_transition_time_y @character.time, 2.0
    @landed = false
  end
  
  def on_unset
    remove_punch_hit_box
    @has_hit_box = false
  end
  
  def update_game_logic time 
    local_time = time - @state_set_time
    
    if @has_hit_box && local_time > @duration * 0.4
      remove_punch_hit_box
    elsif !@has_hit_box && local_time > @duration * 0.18
      @has_hit_box = true
      create_punch_hit_box 'right', 'offset_x' => 0, 'width' => 110, 'strength' => 2.0, 'offset_y' => -150, 'height' => 40
    end
       
    if @character.hit_level_down
      if local_time > @duration * 0.3 && local_time < @duration * 0.4
        return set_state "FallToBackRight", 'start_y' => @character.hit_level_down, 'squelch' => true
      end
      
      if local_time > @duration
        set_state "LandRight", 'start_y' => @character.hit_level_down
      elsif !@landed
        @landed = true
        movement_command = Factories::MovementCommand.construct(entity_manager, entity, time, 'on_surface' => true, 'velocity' => 0, 'start_y' => @character.hit_level_down)
        @character.time_queue.add time, movement_command
      end
      if @landed
        case controls.latest_horizontal_move
        when 'move right'
          set_velocity time, 720
        when 'move left'
          set_velocity time, -720
        else
          set_velocity time, 0
        end
      end
    else
      if @landed
        @landed = false
        movement_command = Factories::MovementCommand.construct(entity_manager, entity, time, 'on_surface' => false)
        @character.time_queue.add time, movement_command
      else
        if local_time > @duration
          set_state 'InAirRight'
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
end