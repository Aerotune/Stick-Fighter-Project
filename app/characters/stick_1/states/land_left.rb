class Characters::Stick1::States::LandLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['land'].merge 'factor_x' => 1, 'fps' => 60, 'mode' => "forward")
    @components = [
      @sprite
    ]
    @duration = @sprite.images.length / @sprite.fps.to_f
  end
  
  def update    
    if @sprite.done
      if controls.control_down? 'move left'
        if @next_state == "JumpLeft"
          set_state @next_state
        else
          set_state "RunLeft"
        end
      elsif controls.control_down? 'move right'
        set_state "RunRight"
      else
        set_state @next_state
      end
    end
    
    @character.x += @vel_x
    #@velocity += @acceleration
    #@character.y += @velocity
  end
  
  def on_hit options
  end
  
  def control_down control
    case control
    when 'attack punch'
      @next_state = "PunchLeft"
    when 'attack jab'
      @next_state = "JabLeft"
    when 'move jump'
      @next_state = "JumpLeft"
    end
  end
  
  def on_set options
    @vel_x = options['velocity_x'].to_f
    @sprite.index = 0
    @next_state = "IdleLeft"
  end
end