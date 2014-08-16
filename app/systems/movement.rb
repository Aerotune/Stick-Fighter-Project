module Systems::Movement
  class << self
    
    def update entity_manager, time
      entity_manager.each_entity_with_component Components::Movement do |entity, movement_component|
        position = entity_manager.get_component entity, Components::Position
        if position
          movement = movement_component.movement
          movement.update time
          position.x = position.next_x
          position.y = position.next_y
          position.next_x = movement.x
          position.next_y = movement.y
        end
      end
    end
    
  end
end