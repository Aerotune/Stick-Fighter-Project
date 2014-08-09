class Characters::Stick1V2::States::InAirLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new @character.class.image_resource['pre_land'].merge('factor_x' => 1, 'fps' => 0, 'mode' => "forward")
      
    @components = [
      @sprite
    ]
    @vel_x = 0
  end
  
  def update
    if controls.control_down? 'move jump'
      @velocity += @acceleration*0.4
    elsif controls.control_down? 'move down'
      @velocity += @acceleration*1.5
    else
      @velocity += @acceleration
    end
    @sprite.fps = @velocity < -5 ? 0 : 27
    @character.y += @velocity
    
    @character.x += @vel_x
    if @character.y > 500
      @character.y = 500
      set_state "LandLeft", 'velocity_x' => @vel_x*0.3
    end
  end
  
  def control_down control
    case control
    when 'move right'
      @vel_x = 5
    when 'move left'
      @vel_x = -12
    end
  end
  
  def control_up control
    case control
    when 'move right'
      @vel_x = controls.control_down?('move left') ? -12 : 0
    when 'move left'
      @vel_x = controls.control_down?('move right') ? 5 : 0
    end
  end
  
  def on_hit options
  end
  
  def on_set options
    @velocity = -20
    @acceleration = 1.8
    @sprite.index = 0
    @vel_x = 0
    @vel_x = 5 if controls.control_down? 'move right'
    @vel_x = -12 if controls.control_down? 'move left'
    
    
  end
end