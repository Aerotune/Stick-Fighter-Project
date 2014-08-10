class Characters::Stick1V2::States::BlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['block'].merge 'factor_x' => -1, 'fps' => 0, 'mode' => "forward")
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
    when 'move up'
      set_state "JumpRight"
    when 'attack punch'
      set_state "PunchRight"
    when 'attack jab'
      set_state "JabRight"
    end
  end
  
  def control_up control
    case control
    when 'block'
      set_state "PreBlockRight", {'mode' => "backward"}
    end
  end
  
  def on_hit options
    case options['punch_direction']
    when 'left'
      @sprite.index = 1
      @sprite.fps = 37
      @character.x -= 2
    when 'right'
      set_state 'PunchedBehindRight'
    end
  end
end