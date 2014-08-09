class Characters::Stick1V2::States::IdleLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @components = [
      Components::Sprite.new(@character.class.image_resource['idle'].merge 'factor_x' => 1)
    ]
    
    @control_down_triggers = {
      'move right' => "RunRight",
      'move left' => "RunLeft",
      'move jump' => "JumpLeft",
      'attack punch' => "PunchLeft",
      'attack jab' => "JabLeft",
      'block' => "PreBlockLeft"
    }
    
    @punch_trigger = {
      'left' => "PunchedBehindLeft",
      'right' => "PunchedFrontLeft"
    }
  end
end