module Systems::Movement
  class << self
    
    def update entity_manager, time
      entity_manager.each_entity_with_component Components::Movement do |entity, movement_component|
        movement = movement_component.movement
        position = entity_manager.get_component entity, Components::Position
        movement.update time
        position.x = movement.x
        position.y = movement.y
      end
    end
    
  end
end