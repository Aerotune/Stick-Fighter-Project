module Factories::Player
  $characters = {}
  
  def self.construct entity_manager, x, y, controls, tint_color, initial_state=:IdleRight
    entity = entity_manager.create_entity
    
    position = Components::Position.new(x, y)
    #tint = Components::Tint.new(tint_color)
    hit_box_width = 60
    hit_box_height = 200
    hit_box = Components::HitBox.new(x-hit_box_width/2.0, y-hit_box_height, hit_box_width, hit_box_height)
    
    entity_manager.add_component entity, position
    #entity_manager.add_component entity, tint
    entity_manager.add_component entity, hit_box
    
    character = Characters::Stick1.new entity_manager, entity, Settings::CONTROLS[controls]
    character.set_state initial_state
    $characters[entity] = character
    character
  end
end