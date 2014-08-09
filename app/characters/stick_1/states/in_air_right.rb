class Characters::Stick1::States::InAirRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new @character.class.image_resource['pre_land'].merge('factor_x' => -1, 'fps' => 0, 'mode' => "forward")
      
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
      set_state "LandRight", 'velocity_x' => @vel_x*0.3
    end
  end
  
  def control_down control
    case control
    when 'move right'
      @vel_x = 12
    when 'move left'
      @vel_x = -5
    end
  end
  
  def control_up control
    case control
    when 'move right'
      @vel_x = controls.control_down?('move left') ? -5 : 0
    when 'move left'
      @vel_x = controls.control_down?('move right') ? 12 : 0
    end
  end
  
  def on_hit
  end
  
  def on_set options
    @velocity = -20
    @acceleration = 1.8
    @sprite.index = 0
    @vel_x = 0
    @vel_x = -5 if controls.control_down? 'move left'
    @vel_x = 12 if controls.control_down? 'move right'
    
  end
end