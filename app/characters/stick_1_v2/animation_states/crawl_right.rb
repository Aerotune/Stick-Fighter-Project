class Characters::Stick1V2::AnimationStates::CrawlRight < Character::State  
  def initialize character
    @character = character
    @sprite_sheet_id = 'crawl'
    @sprite_options = {'factor_x' => -1, 'fps' => 30}
    @movement_options = {'on_surface' => true, 'velocity' => 520}
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
      return set_state "CrawlToDuckRight"
    end
    
    case controls.latest_horizontal_move
    when 'move right'
      set_velocity time, 520
    when 'move left'
      set_state "CrawlToDuckRight"
    else
      set_state "CrawlToDuckRight"
    end
  end
end