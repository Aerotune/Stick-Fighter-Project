module Factories::Player
  def self.construct entity_manager, stage, x, y, controls, tint_color, initial_state="IdleRight"
    entity = entity_manager.create_entity
    
    position = Components::Position.new(x, y)
    tint = Components::Tint.new(tint_color)
    hit_box_width = 60
    hit_box_height = 190
    hit_box = Components::HitBox.new(-hit_box_width/2.0, -hit_box_height, hit_box_width, hit_box_height)
    
    entity_manager.add_component entity, position
    entity_manager.add_component entity, tint
    entity_manager.add_component entity, hit_box
    
    controls = Settings::CONTROLS[controls]
    
    character = Characters::Stick1V2.new entity_manager, entity, stage, controls
    Commands::SetState.new(character, initial_state, stage.time).do!
    controls.add_listener character
    character
  end
end