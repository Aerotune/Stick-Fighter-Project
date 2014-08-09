class Characters::Stick1V2::States::SlideRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['slide'].merge 'factor_x' => -1, 'fps' => 45)
    @components = [
      @sprite
    ]
    
    @punch_trigger = {
      'left' => "PunchedFrontRight",
      'right' => "PunchedBehindRight"
    }
  end
  
  def update
    if @sprite.index.to_i == @sprite.images.length - 1
      if controls.control_down? 'move left'
        set_state "RunLeft"
      elsif controls.control_down? 'block'
        set_state "PreBlockRight"
      else
        set_state @next_state
      end
    end
    @character.x += 1.5
  end
  
  def control_down control
    case control
    when 'move right'; set_state "RunRight"
    when 'attack punch';  @next_state = "PunchRight"
    when 'attack jab';    @next_state = "JabRight"
    when 'move jump'
      set_state "JumpRight"
    end
  end
  
  def on_set options
    @next_state = "IdleRight"
    @sprite.index = 0
  end
end