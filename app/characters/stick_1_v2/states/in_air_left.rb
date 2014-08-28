class Characters::Stick1V2::States::InAirLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite_sheet_id = 'pre_land'
    @sprite_options = {'factor_x' => 1, 'fps' => 34, 'mode' => "forward"}
    @movement_options = {'on_surface' => false}
  end
  
  def on_set options
    @fast_fall = false
  end
  
  def control_down control
    case control
    when 'move down'
      set_in_air_transition_time_y @character.time, 0.86701
      @fast_fall = true
    when 'attack punch'
      case controls.latest_move
      when "move up"
        set_state "InAirKickUpLeft"
      when "move left"
        set_state "InAirKickLeft"
      when "move down"
        set_state "InAirAttackDownLeft"
      else
        set_state "InAirPunchLeft"
      end
    end
  end
  
  def update_game_logic time    
    if @character.hit_level_down
      set_state "LandLeft", 'start_y' => @character.hit_level_down
    else
      set_in_air_transition_time_y @character.time, 1.945625 if !@fast_fall && !controls.control_down?('move up')
      case controls.latest_horizontal_move
      when 'move right'
        set_in_air_velocity_x time, 720
      when 'move left'
        set_in_air_velocity_x time, -720
      else
        set_in_air_velocity_x time, 0
      end
      
      #if controls.control_down?('move up')
      #  set_in_air_transition_time_y time, 2.83
      #else
      #  
      #end
      
      #if velocity_y(time) > 0
      #  update_sprite time, 'fps' => 27
      #end
    end
  end
end