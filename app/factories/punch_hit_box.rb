module Factories::PunchHitBox
  def self.construct character, punch_direction
    width  = 70
    height = 50
    case punch_direction
    when "right"; offset_x = 38
    when "left";  offset_x = -(38 + width)      
    end
    offset_y = -151
    x = character.x + offset_x
    y = character.y + offset_y
    
    punch_hit_box = Components::PunchHitBox.new(punch_direction, x, y, width, height)
    
    
    character.add_component punch_hit_box
    punch_hit_box
  end
end