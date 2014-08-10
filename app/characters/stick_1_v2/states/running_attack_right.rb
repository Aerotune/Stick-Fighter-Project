class Characters::Stick1V2::States::RunningAttackRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['dash_kick'].merge 'factor_x' => -1, 'duration' => 0.6, 'mode' => "forward")
    @components = [
      @sprite
    ]
  end
  
  def update
    case @sprite.progress
    when 0..0.3
      @character.x += 12
    when 0.35..0.45
      create_punch_hit_box "right"
    when 0.45..1.0
      remove_punch_hit_box
    end
    
    if @sprite.done?
      remove_punch_hit_box
      set_state "IdleRight"
    end
  end
  
  def on_unset
    remove_punch_hit_box
  end
  
  def on_set options
    @sprite.index = 0
  end
end