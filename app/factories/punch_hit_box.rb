module Factories::PunchHitBox
  def self.construct character, hit_direction, options
    width  = options['width']    || 110
    height = options['height']   || 50
    offset = options['offset_x'] || 10
    case hit_direction
    when "right"; offset_x = offset
    when "left";  offset_x = -(offset + width)
    when "down"; offset_x  = options['offset_x'] || 0
    when "up"; offset_x = options['offset_x'] || 0
    end
    offset_y = options['offset_y'] || -151
    strength = options['strength'] || 1.0
    
    Components::PunchHitBox.new(hit_direction, strength, offset_x, offset_y, width, height)
  end
end