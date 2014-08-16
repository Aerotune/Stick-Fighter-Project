require 'json'

Settings::CONTROLS = {}

class Controls
  attr_reader :moves
  
  def initialize control_for_key
    @control_for_key = control_for_key
    @moves = []
    @listeners = []
  end
  
  def [] key_symbol
    @control_for_key[key_symbol]
  end
  
  def add_listener listener
    @listeners << listener
  end
  
  def remove_listener listener
    @listeners.remove listener
  end
  
  def latest_horizontal_move
    (@moves - ['move up']).last
  end
  
  def latest_move
    @moves.last
  end
  
  def control_down? control
    key_symbol = @control_for_key.key(control)
    button_id = KEY_SYMBOLS.key(key_symbol)
    $window.button_down?(button_id)
  end
  
  def button_down id
    key_symbol = KEY_SYMBOLS[id]
    control = @control_for_key[key_symbol]
    if control
      if control.include? 'move'
        @moves << control
      end
      
      @listeners.each do |listener|
        listener.control_down control if listener.respond_to? :control_down
      end
    end
  end
  
  def button_up id
    key_symbol = KEY_SYMBOLS[id]
    control = @control_for_key[key_symbol]
    if control
      if control.include? 'move'
        @moves.delete control
      end
      
      @listeners.each do |listener|
        listener.control_up control if listener.respond_to? :control_up
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), *%w[controls *.rb])].each do |control_file|
  require control_file
end