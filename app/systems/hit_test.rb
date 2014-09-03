module Systems::HitTest
  @vanishing_point_x = $window.width/2.0
  @vanishing_point_y = $window.height/2.0
  @parallax_factor = 1.0
  
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
            
            #punching_character.remove_component punch_hit_box
            unless punch_hit_box.hit_entities.include? hit_box_entity
              punch_hit_box.hit_entities << hit_box_entity
              punched_character.on_hit punch_hit_box#'hit_direction' => punch_hit_box.hit_direction, 'strength' => punch_hit_box.strength
            end
            entity_manager.remove_component punching_entity, punch_hit_box
            #$characters[hit_box_entity].on_hit 'hit_direction' => punch_hit_box.hit_direction
          end
        end
      end
    end
    
    
  end
  
  def self.draw entity_manager, camera
    $window.rotate camera.angle, @vanishing_point_x, @vanishing_point_y do
      entity_manager.each_entity_with_components Components::HitBox do |entity, hit_boxes|
        position = entity_manager.get_component entity, Components::Position
        
        hit_boxes.each do |hit_box|
          #@vanishing_point_x + (anchor_x - camera.x) * @parallax_factor * camera.zoom
          screen_factor = @parallax_factor * camera.zoom
          hit_box_screen_left = @vanishing_point_x + (position.x + hit_box.offset_x - camera.x) * screen_factor
          hit_box_screen_top  = @vanishing_point_y + (position.y + hit_box.offset_y - camera.y) * screen_factor
          hit_box_screen_right = hit_box_screen_left + hit_box.width  * screen_factor
          hit_box_screen_bottom = hit_box_screen_top + hit_box.height * screen_factor
          
          c = 0x44FF0000
          $window.draw_quad \
            hit_box_screen_left,
            hit_box_screen_top,
            c,
            hit_box_screen_right,
            hit_box_screen_top,
            c,
            hit_box_screen_right,
            hit_box_screen_bottom,
            c,
            hit_box_screen_left,
            hit_box_screen_bottom,
            c, ZOrder::HIT_BOX
        end
      end
      
      entity_manager.each_entity_with_components Components::PunchHitBox do |entity, hit_boxes|
        position = entity_manager.get_component entity, Components::Position
        
        hit_boxes.each do |hit_box|
          screen_factor = @parallax_factor * camera.zoom
          hit_box_screen_left = @vanishing_point_x + (position.x + hit_box.offset_x - camera.x) * screen_factor
          hit_box_screen_top  = @vanishing_point_y + (position.y + hit_box.offset_y - camera.y) * screen_factor
          hit_box_screen_right = hit_box_screen_left + hit_box.width  * camera.zoom
          hit_box_screen_bottom = hit_box_screen_top + hit_box.height * camera.zoom
          c = 0x7700FF00
          $window.draw_quad \
            hit_box_screen_left,
            hit_box_screen_top,
            c,
            hit_box_screen_right,
            hit_box_screen_top,
            c,
            hit_box_screen_right,
            hit_box_screen_bottom,
            c,
            hit_box_screen_left,
            hit_box_screen_bottom,
            c, ZOrder::HIT_BOX
        end
      end
    end
  end
end