class TimeQueue
  
  class Event
    attr_reader :time, :command
    def initialize time, command
      @time = time
      @command = command
    end
  end
  
  class AddingEventsToThePastError < RuntimeError; end
  
  attr_reader :future_events, :past_events
  
  def initialize
    @current_time = -1/0.0
    @future_events = []
    @past_events   = []
  end
  
  def set_time! new_time
    current_events = pop_current_events(new_time)
    current_events["undo"].reverse_each do |event|
      event.command.undo!
    end
    current_events["do"].each do |event|
      event.command.do!
    end
  end
  
  def add_command time, command
    raise AddingEventsToThePastError if @current_time > time
    @sorted = false
    @future_events << Event.new(time, command)
  end
  
  
  private
  
  
  def sort!
    unless @sorted
      @sorted = true
      @future_events.sort! { |event_1, event_2| event_1.time <=> event_2.time }
    end
  end
  
  def pop_current_events new_time    
    sort!
    
    if new_time > @current_time
      # Moving forward in time!
      @current_time = new_time
      return {'do' => pop_future_events, 'undo' => []}
    elsif new_time < @current_time
      # Moving back in time!
      @current_time = new_time      
      return {'do' => [], 'undo' => pop_past_events}
    else
      # Already called before with the same time
      return {'do' => [], 'undo' => []}
    end
  end
  
  def pop_future_events
    last_index = 0
    last_index += 1 while @future_events[last_index] && @current_time >= @future_events[last_index].time
    range = 0 ... last_index
    
    current_events = @future_events[range]
    @future_events[range] = []
    @past_events.push *current_events
    current_events
  end
  
  def pop_past_events
    begin_index = @past_events.length
    begin_index -= 1 while begin_index > 0 && @past_events[begin_index-1] && @current_time < @past_events[begin_index-1].time      
    range = begin_index ... @past_events.length
    
    current_events = @past_events[range]
    @past_events[range] = []
    @future_events.unshift *current_events    
    current_events
  end
end