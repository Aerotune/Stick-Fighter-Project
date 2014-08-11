class Commands::SetState < Command
  def initialize stage, character, state_name, state_options={}
    @stage = stage
    @character = character
    @state_name = state_name
    @state_options = state_options
  end
  
  def do_action
    @character.set_state @state_name, @state_options
    @character.states[@state_name].on_set_events.each do |event|
      @stage.time_queue.add_event event
    end
    @stage.time_queue.set_time! @stage.time
  end
end