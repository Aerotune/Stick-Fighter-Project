class HitMaskGrid
  attr_reader :range_x, :range_y, :width, :height
  
  def initialize
    @cell_size = 512
    @hit_masks = [
      [Ashton::Texture.new(Gosu::Image.new($window, 'slices/images/hitmask_alpha_01.png', true)),Ashton::Texture.new(Gosu::Image.new($window, 'slices/images/hitmask_alpha_02.png', true))],
      [Ashton::Texture.new(Gosu::Image.new($window, 'slices/images/hitmask_alpha_03.png', true)),Ashton::Texture.new(Gosu::Image.new($window, 'slices/images/hitmask_alpha_04.png', true))]
    ]
    @width = 1000
    @height = 600
    
    @range_x = (0...@width)
    @range_y = (0...@height)
  end
  
  def find_surface_y x, y
    if transparent? x, y
      20.times do |i|
        unless transparent? x, y+i
          return y+i
        end
      end
    else
      20.times do |i|
        if transparent? x, y-i
          return y-i
        end
      end
    end
    return y
  end
  
  def [] x, y
    cell_x = x/@cell_size
    cell_y = y/@cell_size
    texture_x = x % @cell_size
    texture_y = y % @cell_size
    @hit_masks[cell_y][cell_x][texture_x, texture_y]
  end
  
  def transparent? x, y
    cell_x = x/@cell_size
    cell_y = y/@cell_size
    texture_x = x % @cell_size
    texture_y = y % @cell_size
    hit_mask = @hit_masks[cell_y][cell_x]
    return false unless hit_mask
    @hit_masks[cell_y][cell_x].transparent? texture_x, texture_y
  end
end