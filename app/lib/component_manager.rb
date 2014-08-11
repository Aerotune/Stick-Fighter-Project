class ComponentManager
  def initialize entity_manager
    @entity_manager = entity_manager
    @components = {}
  end
  
  def add_component component
    @components[component.id] = component
  end
  
  def get_component component_id
    
  end
end