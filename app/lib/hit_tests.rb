require_relative 'range_overlaps'

module HitTests
  class << self
    
    def hit_bottom? box_left, box_right, box_top, box_bottom, line_left, line_right, line_y
      (line_left .. line_right).overlaps?(box_left .. box_right) &&
      (line_y >= box_top) &&
      (line_y <= box_bottom)
    end
    
  end
end