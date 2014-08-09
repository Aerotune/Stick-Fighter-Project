class Character::State
  def control_down control
    if @control_down_triggers
      state_name = @control_down_triggers[control]
      set_state state_name if state_name
    end
  end
  
  def control_up control
    
  end
  
  def set_state state_name, options={}
    @character.set_state state_name, options
  end
  
  def controls
    @character.controls
  end
  
  def update
    
  end
  
  def on_set options
    
  end
  
  def on_unset
    
  end
  
  def on_hit options
    if @punch_trigger
      state_name = @punch_trigger[options['punch_direction']]
      set_state state_name if state_name
    end
  end
  
  def create_punch_hit_box direction
    return if @punch_hit_box
    @punch_hit_box = Factories::PunchHitBox.construct @character, direction
  end
  
  def remove_punch_hit_box
    if @punch_hit_box
      @character.remove_component @punch_hit_box
      @punch_hit_box = nil
    end
  end
end