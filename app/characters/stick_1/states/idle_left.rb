class Characters::Stick1::States::IdleLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @components = [
      Components::Sprite.new(@character.class.image_resource['idle'].merge 'factor_x' => 1)
    ]
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
    when 'block'
      set_state "PreBlockLeft"
    end
  end
  
  def on_hit options
    set_state "PunchedLeft"
  end
end