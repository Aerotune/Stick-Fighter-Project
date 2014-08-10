class Characters::Stick1V2::States::RunRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['run_loop'].merge 'factor_x' => -1, 'fps' => 30)
    @components = [
      @sprite
    ]
    
    @punch_trigger = {
      'left' => "PunchedFrontRight",
      'right' => "PunchedBehindRight"
    }
  end
  
  def update
    @character.x += 12
  end
  
  def on_set options
    @sprite.index = 11
  end
  
  def control_down control
    case control
    when 'move up'
      set_state "JumpRight"
    end
  end
  
  def control_up control
    case control
    when 'move right'
      set_state "SlideRight"
    end
  end
end