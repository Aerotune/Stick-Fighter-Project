module Factories::PunchHitBox
  def self.construct character, punch_direction, options
    width  = options['width']    || 70
    height = options['height']   || 50
    offset = options['offset_x'] || 50
    case punch_direction
    when "right"; offset_x = offset
    when "left";  offset_x = -(offset + width)      
    end
    offset_y = options['offset_y'] || -151
    
    Components::PunchHitBox.new(punch_direction, offset_x, offset_y, width, height)
  end
end