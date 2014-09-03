class Characters::Stick1V2::AnimationStates::CrawlToDuckRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'duck_to_crawl'
    @duration = 0.2
    @sprite_options = {'factor_x' => -1, 'duration' => @duration, 'mode' => 'backward'}
    @movement_options = {'on_surface' => true, 'velocity' => 0}
    @controller_states = ["DuckingReactivesRight"]
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
    return set_state "InAirRight" unless @character.hit_level_down
    if controls.control_down? 'move up'
      return set_state "DuckToStandRight"
    end
    local_time = time - @state_set_time
    
    if local_time > @duration
      case controls.latest_horizontal_move
      when 'move right'
        set_state "DuckToCrawlRight"
      when 'move left'
        set_state "DuckToCrawlLeft"
      end
    end 
  end
end