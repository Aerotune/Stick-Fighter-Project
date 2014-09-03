class Characters::Stick1V2::AnimationStates::StandUpFromStomachRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.5
    @sprite_sheet_id = 'stand_up_from_stomach'
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirRight" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      if controls.control_down? 'block'
        case controls.latest_horizontal_move
        when 'move left'; set_state "DashBackwardRight"
        when 'move right';  set_state "DashForwardRight"
        else
          set_state "BlockRight", 'punched' => false
        end
      else
        set_state "IdleRight"
      end
    end
  end
end