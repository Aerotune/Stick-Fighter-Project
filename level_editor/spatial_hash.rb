require_relative 'grid'

class SpatialHash
  def initialize cell_size#, cells_in_x_axis=0, cells_in_y_axis=0
    @cell_size = cell_size.to_f
    @grid = Grid.new# cells_in_x_axis, cells_in_y_axis
    @object_cell_bounds = {}
  end
  
  def [] x, y
    cell_x = x < 0 ? (x/@cell_size).floor : (x/@cell_size).ceil
    cell_y = y < 0 ? (y/@cell_size).floor : (y/@cell_size).ceil
    get_cell cell_x, cell_y
  end
  
  def get_cell cell_x, cell_y
    @grid[cell_x, cell_y] ||= []
  end
  
  def add object, cell_bounds=cell_bounds_for(object.bounding_box)
    @object_cell_bounds[object] = cell_bounds
    cell_bounds[0].each do |cell_x|
      cell_bounds[1].each do |cell_y|
        cell = get_cell cell_x, cell_y
        cell << object unless cell.include? object
      end
    end
  end
  
  def remove object
    cell_bounds = @object_cell_bounds[object]
    cell_bounds[0].each do |cell_x|
      cell_bounds[1].each do |cell_y|
        get_cell(cell_x, cell_y).delete object
      end
    end
    @object_cell_bounds.delete object
  end
  
  def update object
    new_cell_bounds = cell_bounds_for(object.bounding_box)
    old_cell_bounds = @object_cell_bounds[object]
    if old_cell_bounds != new_cell_bounds
      remove object
      add object, new_cell_bounds
    end
  end  
    
  def cell_bounds_for bounding_box
    cell_x_range = (bounding_box.left / @cell_size).floor  ..  (bounding_box.right  / @cell_size).ceil
    cell_y_range = (bounding_box.top  / @cell_size).floor  ..  (bounding_box.bottom / @cell_size).ceil
    
    cell_bounds = [cell_x_range, cell_y_range]
    return cell_bounds
  end
  
  def each_cells_in bounding_box, &block
    cell_bounds = cell_bounds_for(bounding_box)
    cell_bounds[0].each do |cell_x|
      cell_bounds[1].each do |cell_y|
        yield get_cell(cell_x, cell_y)
      end
    end
  end
end