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
  attr_reader :time#, :time_queue
  Dir[File.join(File.dirname(__FILE__), *%w[stage *.rb])].each { |file| require file }
  
  def initialize
    @characters = {}
    @level = Stage::Level.new self
    @start_time = nil
    @time = 0
    @live_time = 0
    
    @font = Gosu::Font.new($window, 'arial', 16)
    
    @entity_manager = EntityManager.new
    #@time_queue = TimeQueue.new
    
    @players = {}
    @level_objects = []
    
    add_player 'player1', 500, 200, "IdleRight", [0.5, 0, 0]
    #add_player 'player2', 200, 200, "IdleLeft", [0, 0, 0.5]
  end
  
  #def add_events *events
  #  @time_queue.add_events *events
  #end
  
  def add_player player_control_id, x, y, initial_state, tint
    character = Factories::Player.construct @entity_manager, self, x, y, player_control_id, tint, initial_state
    @players[player_control_id] = character
    @characters[character.entity] = character
  end
  
  def button_down id
    return unless @live_time == @time
    @players.each do |player_control_id, player|
      player.controls.button_down id
    end
  end
  
  def button_up id
    return unless @live_time == @time
    @players.each do |player_control_id, player|
      player.controls.button_up id
    end
  end
  
  def update
    if $window.button_down? Gosu::KbSpace
      @start_time += 2/60.0
    end
    current_time  = Time.now.to_f
    @start_time ||= current_time
    @time         = current_time - @start_time
    
    
    @level.update
    #@time_queue.set_time! @time
    
    Systems::Movement.update @entity_manager, @time
    
    if @time > @live_time
      @live_time = @time 
      update_game_logic  @time
      #Systems::HitTest.update @entity_manager
    else
      @players.each do |player_control_id, player|
        player.update @time
      end
    end
    Systems::Sprite.update @entity_manager, @time
    #@level.update
  end
  
  def update_game_logic time
    @players.each do |player_control_id, player|
      hit_box  = player.get_component Components::HitBox
      position = player.get_component Components::Position
      
      player.hit_level_down = nil
      player.hit_level_up   = nil
      
      @level.objects.each do |object|
        left        = position.x      + hit_box.offset_x
        right       = left            + hit_box.width
        top         = position.y      + hit_box.offset_y
        bottom      = top             + hit_box.height
        next_top    = position.next_y + hit_box.offset_y
        next_bottom = next_top        + hit_box.height
        
        
        hit_down = (bottom <= object.top) && (next_bottom >= object.top) &&
                   (object.left .. object.right) === position.x
        
        hit_up   = (top >= object.bottom) && (next_top <= object.bottom) &&
                   (object.left .. object.right) === position.x
        
        player.hit_level_down = object.top    if hit_down
        player.hit_level_up   = object.bottom if hit_up
      end
      
      
      player.update @time
      player.update_game_logic @time
    end
  end
  
  def draw
    position = @characters.values.first.get_component(Components::Position)
    if position.y > 4000
      $window.reset_stage
    end
    $window.scale 0.45, 0.45, $window.width/2, $window.height/2 do
      $window.translate -position.x+$window.width/2, -position.y+$window.height/3*2 do
        
        @level.draw
        Systems::Sprite.draw @entity_manager
      end
    end
    if @time < @live_time
      if $window.button_down? Gosu::KbSpace
        @font.draw "REPLAY <<", 10, 10, 0
      else
        @font.draw "REPLAY >>", 10, 10, 0
      end
    end
    #Systems::HitTest.draw @entity_manager
  end
end