module Systems::HitTest
  def self.boxes_hit? box1, box2
    (box1.left .. box1.right) .overlaps?(box2.left .. box2.right) &&
    (box1.top  .. box1.bottom).overlaps?(box2.top  .. box2.bottom)
  end
  
  def self.update entity_manager
    entity_manager.each_entity_with_component Components::HitBox do |entity, hit_box|
      position = entity_manager.get_component entity, Components::Position
      
      hit_box.x = position.x - hit_box.width / 2.0
      hit_box.y = position.y - hit_box.height
    end
    
    
    
    entity_manager.each_entity_with_components Components::PunchHitBox do |punching_entity, punch_hit_boxes|
      
      punch_hit_boxes.each do |punch_hit_box|
        entity_manager.each_entity_with_component Components::HitBox do |hit_box_entity, hit_box|
          next if hit_box_entity == punching_entity
          if boxes_hit? punch_hit_box, hit_box
            entity_manager.remove_component punching_entity, punch_hit_box
            $characters[hit_box_entity].on_hit 'punch_direction' => punch_hit_box.punch_direction
          end
        end
      end
    end
    
    
  end
  
  def self.draw entity_manager
    entity_manager.each_entity_with_component Components::HitBox do |entity, hit_box|
      
      c = 0x44FF0000
      $window.draw_quad \
        hit_box.x,
        hit_box.y,
        c,
        hit_box.x+hit_box.width,
        hit_box.y,
        c,
        hit_box.x+hit_box.width,
        hit_box.y+hit_box.height,
        c,
        hit_box.x,
        hit_box.y+hit_box.height,
        c
    end
    
    entity_manager.each_entity_with_component Components::PunchHitBox do |entity, hit_box|
      
      c = 0x4400FF00
      $window.draw_quad \
        hit_box.x,
        hit_box.y,
        c,
        hit_box.x+hit_box.width,
        hit_box.y,
        c,
        hit_box.x+hit_box.width,
        hit_box.y+hit_box.height,
        c,
        hit_box.x,
        hit_box.y+hit_box.height,
        c
    end
  end
end