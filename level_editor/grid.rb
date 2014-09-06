require_relative 'array2d'

class Grid
  def initialize
    @array2d_bottom_right  = Array2D.new
    @array2d_top_right     = Array2D.new
    @array2d_top_left      = Array2D.new
    @array2d_bottom_left   = Array2D.new
  end
  
  def [] x, y
    if x > 0
      if y > 0
        @array2d_bottom_right[x, y]
      else
        @array2d_top_right[x, -y]
      end
    else
      if y > 0
        @array2d_bottom_left[-x, y]
      else
        @array2d_top_left[-x, -y]
      end
    end
  end
  alias get []
  
  def []= x, y, value
    if x.to_i > 0
      if y.to_i > 0
        @array2d_bottom_right[x, y] = value
      else
        @array2d_top_right[x, -y] = value
      end
    else
      if y.to_i > 0
        @array2d_bottom_left[-x, y] = value
      else
        @array2d_top_left[-x, -y] = value
      end
    end
  end
  alias set []=
end