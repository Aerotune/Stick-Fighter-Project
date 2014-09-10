class SurfacePoints
  attr_accessor :points, :start_point, :end_point
  
  def initialize
    @points = []
    #@start_point = []
    #@end_point = []
  end
  
  def loop?
    @start_point && !@start_point.empty? && @start_point == @end_point
  end
end