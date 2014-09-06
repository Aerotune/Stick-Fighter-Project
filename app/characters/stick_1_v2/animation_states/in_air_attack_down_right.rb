class Characters::Stick1V2::AnimationStates::InAirAttackDownRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.5
    @sprite_sheet_id = 'in_air_attack_down'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
    @controller_states = ["InAirReactivesRight"]
  end
  
  def on_set options
    #set_in_air_transition_time_y @character.time, 2.0
    @landed = false
    @has_hit_box = false
  end
  
  def update_game_logic time 
    local_time = time - @state_set_time
    
    if local_time > @duration * 0.7 && @has_hit_box
      remove_punch_hit_box
    end
    if local_time > @duration * 0.4 && !@has_hit_box
      @has_hit_box = true
      create_punch_hit_box 'down', 'strength' => 2.0, 'width' => 100, 'offset_x' => -50, 'offset_y' => -70
    end
       
    if @character.hit_level_down
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