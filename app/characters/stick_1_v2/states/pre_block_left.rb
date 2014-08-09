class Characters::Stick1V2::States::PreBlockLeft < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['pre_block'].merge 'factor_x' => 1, 'fps' => 45, 'mode' => "forward")
    @components = [
      @sprite
    ]
    
    @punch_trigger = {
      'left' => "PunchedBehindLeft",
      'right' => "PunchedFrontLeft"
    }
  end
  
  def on_set options
    if options["mode"] == "backward"
      @sprite.index = @sprite.images.length-0.01
      @sprite.mode = "backward"
    else
      @sprite.index = 0.01
      @sprite.mode = "forward"
    end
  end
  
  def update
    if @sprite.done
      case @sprite.mode
      when "forward"
        set_state "BlockLeft"
      when "backward"
        set_state "IdleLeft"
      end
    end
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
      @sprite.mode = "forward"
    end
  end
  
  def control_up control
    case control
    when 'block'
      @sprite.mode = "backward"
    end
  end
  
  def on_hit options
    if @sprite.mode == "forward" && @sprite.index > @sprite.images.length/2
      case options['punch_direction']
      when 'right'
        set_state "BlockLeft"
        @character.on_hit
      when 'left'
        set_state 'PunchedBehindLeft'
      end      
    else
      super(options)
    end
  end
end