class Numeric
  def seconds
    self
  end
  
  alias :sec :seconds
  alias :second :seconds
  
  def milliseconds
    self/1000.0
  end
  
  alias :ms :milliseconds
  alias :millisecond :milliseconds
end