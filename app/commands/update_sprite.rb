class Commands::UpdateSprite < Command
  def initialize entity_manager, entity, options
    @entity_manager = entity_manager
    @entity = entity
    @options = options
  end
  
  def do_action
    sprite = @entity_manager.get_component @entity, Components::Sprite
    
    @prev_values = {}
    @options.each do |variable, value|
      @prev_values[variable] = sprite.instance_variable_get("@#{variable}")
      sprite.instance_variable_set("@#{variable}", value)
    end
  end
  
  def undo_action
    sprite = @entity_manager.get_component @entity, Components::Sprite
    
    @prev_values.each do |variable, value|
      sprite.instance_variable_set("@#{variable}", value)
    end
  end
end