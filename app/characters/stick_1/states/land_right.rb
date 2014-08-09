class Characters::Stick1::States::LandRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['land'].merge 'factor_x' => -1, 'fps' => 60, 'mode' => "forward")
    @components = [
      @sprite
    ]
    @duration = @sprite.images.length / @sprite.fps.to_f
  end
  
  def update    
    if @sprite.done
      if controls.control_down? 'move right'
        if @next_state == "JumpRight"
          set_state @next_state
        else
          set_state "RunRight"
        end
      elsif controls.control_down? 'move left'
        set_state "RunLeft"
      else
        set_state @next_state
      end
    end
    
    @character.x += @vel_x
    #@velocity += @acceleration
    #@character.y += @velocity
  end
  
  def on_hit
  end
  
  def control_down control
    case control
    when 'attack punch'
      @next_state = "PunchRight"
    when 'attack jab'
      @next_state = "JabRight"
    when 'move jump'
      @next_state = "JumpRight"
    end
  end
  
  def on_set options
    @vel_x = options['velocity_x'].to_f
    @sprite.index = 0
    @next_state = "IdleRight"
  end
end