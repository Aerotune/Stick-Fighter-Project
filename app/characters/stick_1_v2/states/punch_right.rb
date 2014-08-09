class Characters::Stick1V2::States::PunchRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['punch'].merge 'factor_x' => -1, 'fps' => 33, 'mode' => "forward")
    @components = [
      @sprite
    ]
    @duration = @sprite.images.length / @sprite.fps.to_f
  end
  
  def update
    @character.x += 0.35
    time_passed = Time.now.to_f - @time_set
    if time_passed > @duration
      if controls.control_down? 'move right'
        set_state "RunRight"
      elsif controls.control_down? 'move left'
        set_state "RunLeft"
      elsif controls.control_down? 'block'
        set_state "PreBlockRight"
      else
        set_state @next_state
      end
    elsif time_passed > @duration / 2.5
      if time_passed < @duration / 1.5
        create_punch_hit_box "right"
      else
        remove_punch_hit_box
      end
    end
  end
  
  def control_down control
    case control
    when 'attack punch'; @next_state = "PunchRight"
    when 'attack jab';   @next_state = "JabRight"
    end
  end
  
  def on_set options
    @next_state = "IdleRight"
    @time_set = Time.now.to_f
    @sprite.index = 0
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def on_hit
    set_state "PunchedFrontRight"
  end
end