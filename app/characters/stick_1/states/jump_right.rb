class Characters::Stick1::States::JumpRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['jump'].merge 'factor_x' => -1, 'fps' => 45, 'mode' => "forward")
    @components = [
      @sprite
    ]
    @duration = @sprite.images.length / @sprite.fps.to_f
    @vel_x = 0
  end
  
  def update
    time_passed = Time.now.to_f - @time_set
    
    if time_passed >= @duration
      set_state "InAirRight"
    elsif time_passed > @duration/2.0
      @character.y -= 20
    end
    
    @vel_x = 0
    @vel_x = -5 if controls.control_down? 'move left'
    @vel_x = 12 if controls.control_down? 'move right'
    @character.x += @vel_x
    #@velocity += @acceleration
    #@character.y += @velocity
  end
  
  def on_hit
  end
  
  def on_set options
    @time_set = Time.now.to_f
    @sprite.index = 0
    #@vel_x = 0
    #@vel_x = 12 if controls.control_down? 'move right'
    #@vel_x = -12 if controls.control_down? 'move right'
  end
end