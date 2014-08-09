class Characters::Stick1::States::IdleRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @components = [
      Components::Sprite.new(@character.class.image_resource['idle'].merge factor_x: -1)
    ]
  end
  
  def control_down control
    case control
    when 'move right'
      set_state :RunRight
    when 'move left'
      set_state :RunLeft
    when 'move jump'
      set_state :JumpRight
    when 'attack punch'
      set_state :PunchRight
    when 'attack jab'
      set_state :JabRight
    when 'block'
      set_state :PreBlockRight
    end
  end
  
  def on_hit
    set_state :PunchedRight
  end
end