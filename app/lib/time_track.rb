class TimeTrack
  def initialize
    @start_time = 0
    @time_queue = TimeQueue.new
  end
  
  def update main_time
    @local_time = main_time - @start_time
    @time_queue.set_time! @local_time
  end
  
  def set_time local_time, main_time
    @start_time = main_time - local_time
  end
  
  def add_event time, command
    @time_queue.add_event time, command
  end
end