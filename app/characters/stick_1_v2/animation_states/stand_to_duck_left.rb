class Characters::Stick1V2::AnimationStates::StandToDuckLeft < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'stand_to_duck'
    @duration = 0.35
    @sprite_options = {'factor_x' => 1, 'duration' => 0.3, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["DuckingReactivesLeft"]
  end
  
  def update_game_logic time
    local_time = time - @state_set_time
    progress = local_time / (@duration*0.7)
    progress = 1.0 if progress > 1.0
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0*(1.0-progress*0.5)
    hit_box.offset_y = -hit_box.height
  end
  
  def on_unset
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0
    hit_box.offset_y = -hit_box.height
  end
  
  def control_up control
    case control
    when 'move down'
      set_state 'IdleLeft'
    end
  end
end