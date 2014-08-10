class Characters::Stick1V2::States::StandUpFromBackRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['stand_up_from_back'].merge 'factor_x' => -1, 'duration' => 0.7, 'mode' => 'forward')
    @components = [
      @sprite
    ]
  end
  
  def update
    if @sprite.done?
      set_state "IdleRight"
    end
  end
  
  def on_set options
    @sprite.index = 0
  end
end