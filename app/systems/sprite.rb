module Systems::Sprite
  @vanishing_point_x = 500
  @vanishing_point_y = 300
  @parallax_factor = 1.0
  
  class << self    
    
    def update entity_manager, time
      entity_manager.each_entity_with_components Components::Sprite do |entity, sprites|
        sprites.each do |sprite|
          sprite_time = time - sprite.start_time
          case sprite.mode
          when "forward"
            sprite.index = sprite_time * sprite.fps
            if sprite.index > sprite.images.length-1
              sprite.index = sprite.images.length-1
            end
            sprite.image = sprite.images[sprite.index]
          when "backward"
            sprite.index = sprite.index - sprite_time * sprite.fps
            if sprite.index < 0
              sprite.index = 0
            end
            sprite.image = sprite.images[sprite.index]
          when "loop"
            sprite.index = (sprite_time * sprite.fps) % sprite.images.length
            sprite.image = sprite.images[sprite.index]
          end
          
        end
      end
    end
    
    def draw entity_manager, camera
      entity_manager.each_entity_with_components Components::Image do |entity, image_components|
        position = entity_manager.get_component entity, Components::Position
        tint = entity_manager.get_component entity, Components::Tint
        if position
          image_components.each do |image_component|
            x = position.x
            y = position.y
            screen_x = @vanishing_point_x + (x - camera.x) * @parallax_factor * camera.zoom
            screen_y = @vanishing_point_y + (y - camera.y) * @parallax_factor * camera.zoom
            z = ZOrder::CHARACTER
            angle = 0
            center_x = image_component.center_x.to_f / image_component.image.width
            center_y = image_component.center_y.to_f / image_component.image.height
            factor_x = image_component.factor_x * camera.zoom
            factor_y = 1.0                      * camera.zoom
            if false#tint
              Shaders.tint[:color] = tint.color
              $window.post_process shaders: Shaders.tint, z: z do
                image_component.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
              end
            else
              image_component.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
            end
          end
        end
      end
      
      entity_manager.each_entity_with_components Components::Sprite do |entity, sprites|
        position = entity_manager.get_component entity, Components::Position
        tint = entity_manager.get_component entity, Components::Tint
        if position
          sprites.each do |sprite|
            x = position.x
            y = position.y
            screen_x = @vanishing_point_x + (x - camera.x) * @parallax_factor * camera.zoom
            screen_y = @vanishing_point_y + (y - camera.y) * @parallax_factor * camera.zoom
            z = ZOrder::CHARACTER
            angle = 0
            center_x = sprite.center_x.to_f / sprite.images.first.width
            center_y = sprite.center_y.to_f / sprite.images.first.height
            factor_x = sprite.factor_x  * camera.zoom
            factor_y = 1.0              * camera.zoom
            
            if false#tint
              Shaders.tint[:color] = tint.color
              $window.post_process shaders: Shaders.tint, z: z do
                sprite.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
              end
            else
              sprite.image.draw_rot screen_x, screen_y, z, angle, center_x, center_y, factor_x, factor_y
            end
            
          end
        end
      end
    end
    
  end
end