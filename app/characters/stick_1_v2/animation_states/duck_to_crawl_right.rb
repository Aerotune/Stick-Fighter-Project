class Characters::Stick1V2::AnimationStates::DuckToCrawlRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'duck_to_crawl'
    @duration = 0.2
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true, 'velocity' => 380}
    @controller_states = ["DuckingReactivesRight", "DuckingActivesRight"]
  end
  
  def on_unset
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0
    hit_box.offset_y = -hit_box.height
  end
  
  def on_set options
    hit_box = @character.get_component Components::HitBox
    hit_box.height = 185.0/2.0
    hit_box.offset_y = -hit_box.height
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    local_time = time - @state_set_time
    
    case controls.latest_horizontal_move
    when 'move right'
      set_velocity time, 380
    else
      set_velocity time, 0
    end
    
    if local_time > @duration
      if controls.time_since_control_down('move up') < @duration
        return set_state "DuckToStandRight"
      end
      case controls.latest_horizontal_move
      when 'move left'
        set_state "CrawlLeft"
      when 'move right'
        set_state "CrawlRight"
      else
        set_state "CrawlToDuckRight"
      end
    end
  end
end