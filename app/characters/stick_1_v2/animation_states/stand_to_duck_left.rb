class Characters::Stick1V2::AnimationStates::StandToDuckLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'stand_to_duck'
    @duration = 0.35
    @sprite_options = {'factor_x' => 1, 'duration' => 0.3, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["DuckingReactivesLeft", "OnSurfaceMovement", "DuckingActivesLeft"]
  end
  
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    local_time = time - @state_set_time
    progress = local_time / (@duration*0.7)
    progress = 1.0 if progress > 1.0
    hit_box = @character.get_component Components::HitBox
    hit_box.height = (185.0*(1.0-progress*0.5)).round
    hit_box.offset_y = -hit_box.height
    
    if local_time > @duration * 0.6
      
      if controls.time_since_control_down('move up') < @duration * 0.6
        return set_state "DuckToStandLeft"
      end
      
      case controls.latest_horizontal_move
      when 'move left'
        set_state "DuckToCrawlLeft"
      when 'move right'
        set_state "DuckToCrawlRight"
      end      
    end
  end
  
  def on_set options
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0
    hit_box.offset_y = -hit_box.height
  end
  
  def on_unset
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0
    hit_box.offset_y = -hit_box.height
  end
end