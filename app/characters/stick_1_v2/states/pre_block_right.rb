class Characters::Stick1V2::States::PreBlockRight < Character::State
  attr_reader :components
  
  def initialize character
    @character = character
    @sprite = Components::Sprite.new(@character.class.image_resource['pre_block'].merge 'factor_x' => -1, 'fps' => 45, 'mode' => "forward")
    @components = [
      @sprite
    ]
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
    if @sprite.done?
      case @sprite.mode
      when "forward"
        set_state "BlockRight"
      when "backward"
        set_state "IdleRight"
      end
    end
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
      when 'left'
        set_state "BlockRight"
        @character.on_hit options
      when 'left'
        set_state 'PunchedBehindRight'
      end      
    else
      super(options)
    end
  end
end