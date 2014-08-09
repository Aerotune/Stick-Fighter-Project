class Character
  Dir[File.join(File.dirname(__FILE__), *%w[character *.rb])].each { |file| require file }
  
  attr_reader :controls, :state_name
  
  def initialize entity_manager, entity, controls
    @entity_manager = entity_manager
    @entity = entity
    @controls = controls
    @states = {}
    
    @position = @entity_manager.get_component @entity, Components::Position
    
    self.class.load_image_resource
    self.class::States.constants.each do |state_name|
      state_class = self.class::States.const_get(state_name)
      @states[state_name.to_s] = state_class.new self
    end
  end
  
  def update
    @current_state.update
  end
  
  def get_component component_class
    @entity_manager.get_component @entity, component_class
  end
  
  def add_component component
    @entity_manager.add_component @entity, component
  end
  
  def remove_component component
    @entity_manager.remove_component @entity, component
  end
  
  def x
    @position.x
  end
  
  def y
    @position.y
  end
  
  def x= x
    @position.x = x
  end
  
  def y= y
    @position.y = y
  end
  
  def button_down id
    key_symbol = KEY_SYMBOLS[id]
    control_down @controls[key_symbol]
  end
  
  def button_up id
    key_symbol = KEY_SYMBOLS[id]
    control_up @controls[key_symbol]
  end
  
  def control_down control
    @current_state.control_down control
  end
  
  def control_up control
    @current_state.control_up control
  end
  
  def on_hit
    @current_state.on_hit
  end
  
  def set_state state_name, options={}
    raise "state #{state_name.inspect} doesn't exist for #{self.class}" unless @states.has_key? state_name
    
    
    @state_name = state_name
    new_state = @states[@state_name]
    prev_state = @current_state
    
    #return if new_state == prev_state
    
    
    if prev_state
      prev_state.components.each do |component|
        @entity_manager.remove_component @entity, component
      end
      prev_state.on_unset
    end
    @current_state = new_state
    @current_state.components.each do |component|
      @entity_manager.add_component @entity, component
    end
    @current_state.on_set options
  end
  
  class << self
    attr_reader :image_resource
    
    def spritesheets_folder *paths
      @sprite_sheet_paths = Dir[File.join *paths, '*.json']
    end
    
    def load_image_resource
      return @image_resource if @image_resource
      @image_resource = {}
    
      @sprite_sheet_paths.each do |sprite_sheet_path|
        spritesheet = SpriteSheet.load sprite_sheet_path
        @image_resource[spritesheet["name"]] = spritesheet
      end
    end
  end
end