class Characters::Stick1V2::States::SlideLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['slide'].merge 'factor_x' => 1, 'fps' => 45)
    @components = [
      @sprite
    ]
    
    @punch_trigger = {
      'left' => "PunchedBehindLeft",
      'right' => "PunchedFrontLeft"
    }
  end
  
  def update
    if @sprite.index.to_i == @sprite.images.length - 1
      if controls.control_down? 'move right'
        set_state "RunRight"
      elsif controls.control_down? 'block'
        set_state "PreBlockLeft"
      else
        set_state @next_state
      end
    end
    @character.x -= 1.5
  end
  
  def control_down control
    case control
    when 'move left'; set_state "RunLeft"
    when 'attack punch';  @next_state = "PunchLeft"
    when 'attack jab';    @next_state = "JabLeft"
    when 'move jump'
      set_state "JumpLeft"
    end
  end
  
  def on_set options
    @next_state = "IdleLeft"
    @sprite.index = 0
  end
end