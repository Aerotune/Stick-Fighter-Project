class Components::HitBox < Component
  attr_accessor :offset_x, :offset_y, :width, :height
  
  def initialize offset_x, offset_y, width, height
    @offset_x = offset_x
    @offset_y = offset_y
    @width = width
    @height = height
  end
end