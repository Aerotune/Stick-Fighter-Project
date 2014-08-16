class Commands::RemoveComponent < Command
  def initialize entity_manager, entity, component
    @entity_manager = entity_manager
    @entity         = entity
    @component      = component
  end
  
  def do_action
    @entity_manager.remove_component @entity, @component
  end
  
  def undo_action
    @entity_manager.add_component @entity, @component
  end  
end