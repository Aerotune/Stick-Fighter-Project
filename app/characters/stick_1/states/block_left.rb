class Characters::Stick1::States::BlockLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['block'].merge 'factor_x' => 1, 'fps' => 0, 'mode' => "forward")
    @components = [
      @sprite
    ]
  end
  
  def on_set options
    @sprite.fps = 0
    @sprite.index = 0
  end
  
  def update
    
  end
  
  def control_down control
    case control
    when 'move right'
      set_state "RunRight"
    when 'move left'
      set_state "RunLeft"
    when 'move jump'
      set_state "JumpLeft"
    when 'attack punch'
      set_state "PunchLeft"
    when 'attack jab'
      set_state "JabLeft"
    end
  end
  
  def control_up control
    case control
    when 'block'
      set_state "PreBlockLeft", {'mode' => "backward"}
    end
  end
  
  def on_hit options options
    @sprite.index = 1
    @sprite.fps = 37
    @character.x += 2
  end
end