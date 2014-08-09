class Characters::Stick1V2::States::IdleRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @components = [
      Components::Sprite.new(@character.class.image_resource['idle'].merge 'factor_x' => -1)
    ]
    
    @control_down_triggers = {
      'move right' => "RunRight",
      'move left' => "RunLeft",
      'move jump' => "JumpRight",
      'attack punch' => "PunchRight",
      'attack jab' => "JabRight",
      'block' => "PreBlockRight"
    }
  end
  
  def on_hit
    set_state "PunchedFrontRight"
  end
end