=begin

sky color
0xFFFFFFFF #top
0xFFCCFFFF
0xFFFFFFCC #bottom

ground color
0x00DDDDB1 #top
0xFFE0DFC0 #bottom

=end

class Stage
  attr_reader :time, :time_queue
  Dir[File.join(File.dirname(__FILE__), *%w[stage *.rb])].each { |file| require file }
  
  def initialize
    @level = Stage::Level.new
    @start_time = nil
    @time = 0
    
    @entity_manager = EntityManager.new
    @time_queue = TimeQueue.new
    
    @players = {}
    
    add_player 'player1', 500, 500, "IdleLeft", [0.5, 0, 0]
    add_player 'player2', 200, 500, "IdleRight", [0, 0, 0.5]
  end
  
  def add_player player_control_id, x, y, initial_state, tint
    @players[player_control_id] = Factories::Player.construct @entity_manager, self, x, y, player_control_id, tint, initial_state
  end
  
  def button_down id
    @players.each do |player_control_id, player|
      player.button_down id
    end
  end
  
  def button_up id
    @players.each do |player_control_id, player|
      player.button_up id
    end
  end
  
  def update
    #if $window.button_down? Gosu::KbSpace
    #  @start_time += 2/60.0
    #end
    current_time  = Time.now.to_f
    @start_time ||= current_time
    @time         = current_time - @start_time
    
    @time_queue.set_time! @time
    
    
    @players.each do |player_control_id, player|
      player.update
    end
    
    Systems::Movement.update @entity_manager, @time
    Systems::HitTest.update @entity_manager
    Systems::Sprite.update @entity_manager
    #@level.update
  end
  
  def draw
    #@level.draw
    Systems::Sprite.draw @entity_manager
  end
end