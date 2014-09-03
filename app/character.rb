class Character
  Dir[File.join(File.dirname(__FILE__), *%w[character *.rb])].each { |file| require file }
  
  attr_accessor :hit_level_up, :hit_level_down, :hit_level_right, :hit_level_left
  attr_reader :controls, :animation_state_name, :animation_states, :entity_manager, :entity, :stage, :current_animation_state, :time_queue
  
  def initialize entity_manager, entity, stage, controls
    @entity_manager = entity_manager
    @entity = entity
    @stage = stage
    @controls = controls
    @animation_states = {}
    @controller_states = {}
    
    @time_queue = TimeQueue.new
            
    self.class.require_image_resource
    self.class::AnimationStates.constants.each do |state_name|
      state_class = self.class::AnimationStates.const_get(state_name)
      @animation_states[state_name.to_s] = state_class.new self
    end
    
    self.class::ControllerStates.constants.each do |state_name|
      state_class = self.class::ControllerStates.const_get(state_name)
      @controller_states[state_name.to_s] = state_class.new self
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
    if @current_animation_state
      @current_animation_state.update_collision_game_logic time
      @current_animation_state.update_game_logic time 
    end
    
    controller_states = @current_animation_state.controller_states
    if controller_states
      controller_states.each do |controller_state_name|
        controller_state = @controller_states[controller_state_name]
        controller_state.update_game_logic time if controller_state.respond_to? :update_game_logic
      end
    end
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
    @current_animation_state.control_down control if @current_animation_state.respond_to? :control_down
    controller_states = @current_animation_state.controller_states
    if controller_states
      controller_states.each do |controller_state_name|
        controller_state = @controller_states[controller_state_name]
        controller_state.control_down control if controller_state.respond_to? :control_down
      end
    end
  end
  
  def control_up control
    @current_animation_state.control_up control if @current_animation_state.respond_to? :control_up
  end
  
  def on_hit punch_hit_box
    
    $shake = Time.now.to_f
    $shake_amount = 8.0 * punch_hit_box.strength ** 1.4
    
    controller_states = @current_animation_state.controller_states
    if controller_states
      controller_states.each do |controller_state_name|
        controller_state = @controller_states[controller_state_name]
        controller_state.on_hit punch_hit_box if controller_state.respond_to? :on_hit
      end
    end
    @current_animation_state.on_hit punch_hit_box if @current_animation_state.respond_to? :on_hit
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