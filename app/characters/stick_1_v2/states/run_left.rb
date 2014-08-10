class Characters::Stick1V2::States::RunLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['run_loop'].merge 'factor_x' => 1, 'fps' => 30)
    @components = [
      @sprite
    ]
    
    @punch_trigger = {
      'left' => "PunchedBehindLeft",
      'right' => "PunchedFrontLeft"
    }
  end
  
  def update
    @character.x -= 12
  end
  
  def on_set options
    @sprite.index = 11
  end
  
  def control_down control
    case control
    when 'move up'
      set_state "JumpLeft"
    when 'attack punch', 'attack jab'
      set_state "RunningAttackLeft"
    end
  end
  
  def control_up control
    case control
    when 'move left'
      set_state "SlideLeft"
    end
  end
end