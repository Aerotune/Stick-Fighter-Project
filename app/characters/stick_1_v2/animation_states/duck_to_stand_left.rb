class Characters::Stick1V2::AnimationStates::DuckToStandLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'stand_to_duck'
    @duration = 0.35
    @sprite_options = {'factor_x' => 1, 'duration' => 0.3, 'mode' => 'backward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["DuckingReactivesLeft", "OnSurfaceMovement"]
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    local_time = time - @state_set_time
    progress = local_time / (@duration*0.7)
    progress = 1.0 if progress > 1.0
    hit_box = @character.get_component Components::HitBox
    hit_box.height = (185.0*(0.5+progress*0.5)).round
    hit_box.offset_y = -hit_box.height
    
    if local_time > @duration * 0.6
      if controls.control_down?("move up") && controls.time_since_control_down("move up") < @duration * 0.6
        return set_state "JumpLeft"
      end
      case controls.latest_horizontal_move
      when 'move left'
        set_state "RunLeft"
      when 'move right'
        set_state "RunRight"
      else
        set_state "IdleLeft"
      end
    end
  end
  
  def on_set options
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0/2.0
    hit_box.offset_y = -hit_box.height
  end
  
  def on_unset
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0
    hit_box.offset_y = -hit_box.height
  end
end