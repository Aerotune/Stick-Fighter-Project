class Character
  Dir[File.join(File.dirname(__FILE__), *%w[character *.rb])].each { |file| require file }
  
  attr_accessor :hit_level_up, :hit_level_down
  attr_reader :controls, :state_name, :states, :entity_manager, :entity, :stage, :current_state, :time_queue
  
  def initialize entity_manager, entity, stage, controls
    @entity_manager = entity_manager
    @entity = entity
    @stage = stage
    @controls = controls
    @states = {}
    
    @time_queue = TimeQueue.new
            
    self.class.require_image_resource
    self.class::States.constants.each do |state_name|
      state_class = self.class::States.const_get(state_name)
      @states[state_name.to_s] = state_class.new self
    end
  end
  
  def update time
    @time = time
    @time_queue.set_time! time
  end
  
  def time
    @time
  end
  
  def update_game_logic time
    @current_state.update_game_logic time if @current_state
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
  
  def control_down control
    @current_state.control_down control if @current_state.respond_to? :control_down
  end
  
  def control_up control
    @current_state.control_up control if @current_state.respond_to? :control_up
  end
  
  def on_hit options
    @current_state.on_hit options if @current_state.respond_to? :on_hit
  end
  
  class << self
    attr_reader :image_resource
    
    def spritesheets_folder *paths
      @sprite_sheet_paths = Dir[File.join *paths, '*.json']
    end
    
    def require_image_resource
      return @image_resource if @image_resource
      @image_resource = {}
    
      @sprite_sheet_paths.each do |sprite_sheet_path|
        spritesheet = SpriteSheet.load sprite_sheet_path
        @image_resource[spritesheet["name"]] = spritesheet
      end
    end
  end
end