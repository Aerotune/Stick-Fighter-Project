class Characters::Stick1V2::States::StandUpFromBackLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['stand_up_from_back'].merge 'factor_x' => 1, 'duration' => 0.7, 'mode' => 'forward')
    @components = [
      @sprite
    ]
  end
  
  def update_game_logic time
    if @sprite.done?
      set_state "IdleLeft"
    end
  end
  
  def on_set options
    @sprite.index = 0
  end
end