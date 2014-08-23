class Characters::Stick1V2::States::StandUpFromBackLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @duration = 0.6
    @sprite_sheet_id = 'stand_up_from_back'
    @sprite_options = {'factor_x' => 1, 'duration' => @duration, 'mode' => 'forward'}
    @movement_options = {'on_surface' => true}
  end
  
  def update_game_logic time
    return set_state "InAirLeft" unless @character.hit_level_down
    
    local_time = time - @state_set_time
    
    if local_time > @duration
      set_state "IdleLeft"
    elsif (local_time > @duration - 0.25) && !@has_hit_box
      @has_hit_box = true
      @stand_up_hit_box_right = Factories::PunchHitBox.construct @character, 'right', 'offset_x' => 5, 'width' => 65
      @stand_up_hit_box_left  = Factories::PunchHitBox.construct @character, 'left',  'offset_x' => 5, 'width' => 80
      @character.add_component @stand_up_hit_box_right
      @character.add_component @stand_up_hit_box_left
    end
  end
  
  def on_set options
    ease_position 'distance' => -50, 'transition_time' => @duration, 'start_time' => @character.time
    @has_hit_box = false
  end
  
  def on_unset
    @character.remove_component @stand_up_hit_box_right
    @character.remove_component @stand_up_hit_box_left
  end
end