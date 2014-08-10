class Characters::Stick1V2::States::FallToStomachRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['fall_front'].merge 'factor_x' => -1, 'duration' => 0.7, 'mode' => 'forward')
    @components = [
      @sprite
    ]
  end
  
  def control_down control
    if @sprite.done?
      set_state "StandUpFromStomachRight"
    end
  end
  
  def on_set options
    @sprite.index = 0
  end
end