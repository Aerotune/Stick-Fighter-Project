module Systems::Sprite
  class << self
    
    def update entity_manager
      entity_manager.each_entity_with_components Components::Sprite do |entity, sprites|
        sprites.each do |sprite|
          case sprite.mode
          when :forward
            sprite.index = sprite.index + sprite.fps/60.0
            if sprite.index >= sprite.images.length-1
              sprite.index = sprite.images.length-1
              sprite.done = true
            else
              sprite.done = false
            end
            sprite.image = sprite.images[sprite.index]
          when :backward
            sprite.index = sprite.index - sprite.fps/60.0
            if sprite.index <= 0
              sprite.index = 0
              sprite.done = true
            else
              sprite.done = false
            end
            sprite.image = sprite.images[sprite.index]
          when :loop
            sprite.index = (sprite.index + sprite.fps/60.0) % sprite.images.length
            sprite.image = sprite.images[sprite.index]
          end
          
        end
      end
    end
    
    def draw entity_manager
      entity_manager.each_entity_with_components Components::Image do |entity, image_components|
        position = entity_manager.get_component entity, Components::Position
        tint = entity_manager.get_component entity, Components::Tint
        if position
          image_components.each do |image_component|
            x = position.x
            y = position.y
            z = 0
            angle = 0
            center_x = image_component.center_x / image_component.image.width
            center_y = image_component.center_y / image_component.image.height
            factor_x = image_component.factor_x
            if tint
              Shaders.tint[:color] = tint.color
              $window.post_process Shaders.tint do
                image_component.image.draw_rot x, y, z, angle, center_x, center_y, factor_x
              end
            else
              image_component.image.draw_rot x, y, z, angle, center_x, center_y, factor_x
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
            z = 0
            angle = 0
            center_x = sprite.center_x / sprite.images.first.width
            center_y = sprite.center_y / sprite.images.first.height
            factor_x = sprite.factor_x
            
            if tint
              Shaders.tint[:color] = tint.color
              $window.post_process Shaders.tint do
                sprite.image.draw_rot x, y, z, angle, center_x, center_y, factor_x
              end
            else
              sprite.image.draw_rot x, y, z, angle, center_x, center_y, factor_x
            end
            
          end
        end
      end
    end
    
  end
end