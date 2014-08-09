class Characters::Stick1::States::RunLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['run'].merge factor_x: 1, fps: 30)
    @components = [
      @sprite
    ]
  end
  
  def update
    @character.x -= 12
  end
  
  def on_set options
    @sprite.index = 11
  end
  
  def control_down control
    case control
    when 'move jump'
      set_state :JumpLeft
    end
  end
  
  def control_up control
    case control
    when 'move left'
      set_state :SlideLeft
    end
  end
  
  def on_hit
    set_state :PunchedLeft
  end
end