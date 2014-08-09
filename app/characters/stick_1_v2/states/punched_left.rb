class Characters::Stick1V2::States::PunchedFrontLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['punched_front'].merge 'factor_x' => 1, 'fps' => 33, 'mode' => "forward")
    @components = [
      @sprite
    ]
    @duration = @sprite.images.length / @sprite.fps.to_f
  end
  
  def update
    @character.x += 0.25
    if Time.now.to_f - @time_set > @duration
      if controls.control_down? 'move left'
        set_state "RunLeft"
      elsif controls.control_down? 'move right'
        set_state "RunRight"
      elsif controls.control_down? 'block'
        set_state "PreBlockLeft"
      else
        set_state @next_state
      end
    end
  end
  
  def control_down control
    case control
    when 'attack punch'; @next_state = "PunchLeft"
    when 'attack jab';   @next_state = "JabLeft"
    end
  end
  
  def on_set options
    @next_state = "IdleLeft"
    @time_set = Time.now.to_f
    @sprite.index = 0
  end
  
  def on_hit
    set_state "PunchedFrontLeft"
  end
end