require 'json'

Settings::CONTROLS = {}

class Controls
  def initialize control_for_key
    @control_for_key = control_for_key
  end
  
  def [] key_symbol
    @control_for_key[key_symbol]
  end
  
  def control_down? control
    key_symbol = @control_for_key.key(control)
    button_id = KEY_SYMBOLS.key(key_symbol)
    $window.button_down?(button_id)
  end
end

Dir[File.join(File.dirname(__FILE__), *%w[controls *.rb])].each do |control_file|
  require control_file
  #name = File.basename control_file, '.json'
  #raw_json = File.read(control_file)
  #p raw_json[0]
  # JSON.load(raw_json)
end