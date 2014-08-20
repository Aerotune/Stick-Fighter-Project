module Systems::HitTest
  def self.boxes_hit? hit_box1, hit_box1_position, hit_box2, hit_box2_position
    box1_left = hit_box1_position.x + hit_box1.offset_x
    box1_right = box1_left + hit_box1.width
    
    box1_top = hit_box1_position.y + hit_box1.offset_y
    box1_bottom = box1_top + hit_box1.height
    
    box2_left = hit_box2_position.x + hit_box2.offset_x
    box2_right = box2_left + hit_box2.width
    
    box2_top = hit_box2_position.y + hit_box2.offset_y
    box2_bottom = box2_top + hit_box2.height
    
    (box1_left .. box1_right) .overlaps?(box2_left .. box2_right) &&
    (box1_top  .. box1_bottom).overlaps?(box2_top  .. box2_bottom)
  end
  
  def self.update entity_manager, characters
    #entity_manager.each_entity_with_component Components::HitBox do |entity, hit_box|
    #  position = entity_manager.get_component entity, Components::Position
    #  
    #  hit_box.x = position.x - hit_box.width / 2.0
    #  hit_box.y = position.y - hit_box.height
    #end
    
    entity_manager.each_entity_with_components Components::PunchHitBox do |punching_entity, punch_hit_boxes|
      puncher_position = entity_manager.get_component punching_entity, Components::Position
      punch_hit_boxes.each do |punch_hit_box|
        entity_manager.each_entity_with_component Components::HitBox do |hit_box_entity, hit_box|
          hit_position = entity_manager.get_component hit_box_entity, Components::Position
          next if hit_box_entity == punching_entity
          if boxes_hit? punch_hit_box, puncher_position, hit_box, hit_position
            
            punching_character = characters[punching_entity]
            punched_character  = characters[hit_box_entity]
            
            punching_character.remove_component punch_hit_box
            punched_character.on_hit 'punch_direction' => punch_hit_box.punch_direction
            #entity_manager.remove_component punching_entity, punch_hit_box
            #$characters[hit_box_entity].on_hit 'punch_direction' => punch_hit_box.punch_direction
          end
        end
      end
    end
    
    
  end
  
  def self.draw entity_manager
    entity_manager.each_entity_with_components Components::HitBox do |entity, hit_boxes|
      position = entity_manager.get_component entity, Components::Position
      
      hit_boxes.each do |hit_box|
        hit_box_x = position.x + hit_box.offset_x
        hit_box_y = position.y + hit_box.offset_y
        
        c = 0x44FF0000
        $window.draw_quad \
          hit_box_x,
          hit_box_y,
          c,
          hit_box_x+hit_box.width,
          hit_box_y,
          c,
          hit_box_x+hit_box.width,
          hit_box_y+hit_box.height,
          c,
          hit_box_x,
          hit_box_y+hit_box.height,
          c
      end
    end
    
    entity_manager.each_entity_with_components Components::PunchHitBox do |entity, hit_boxes|
      position = entity_manager.get_component entity, Components::Position
      
      
      hit_boxes.each do |hit_box|
        hit_box_x = position.x + hit_box.offset_x
        hit_box_y = position.y + hit_box.offset_y
        
        c = 0x4400FF00
        $window.draw_quad \
          hit_box_x,
          hit_box_y,
          c,
          hit_box_x+hit_box.width,
          hit_box_y,
          c,
          hit_box_x+hit_box.width,
          hit_box_y+hit_box.height,
          c,
          hit_box_x,
          hit_box_y+hit_box.height,
          c
      end
    end
  end
end