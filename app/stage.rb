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
    @camera = Camera.new 1350, 900, 0.8
    @background_camera = Camera.new 1350, 900, 0.8
    @background = Stage::Background.new
    @camera_filtering = 0.01
    @background.update @camera
    @level = Stage::Level.new self
    @start_time = nil
    @time = 0
    @live_time = 0
    
    @font = Gosu::Font.new($window, 'Arial', 16)
    
    @entity_manager = EntityManager.new
    #@time_queue = TimeQueue.new
    
    @players = {}
    @level_objects = []
    
    add_player 'player2', 200, 200, "IdleRight", [0.2, 0.0, 0.4]
    add_player 'player1', 2500, 1600, "IdleLeft", [0.4, 0.05, 0.0]
  end
  
  def live?
    @time >= @live_time
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
        
    if @time > @live_time
      @live_time = @time 
      update_game_logic  @time
    else
      update_replay @time
    end
    Systems::Sprite.update @entity_manager, @time
  end
  
  def shared_update time
    #if $window.button_down?(Gosu::Kb0)
    #  @camera.zoom += 0.01
    #elsif $window.button_down?(Gosu::Kb9)
    #  @camera.zoom -= 0.01
    #end
    
    camera_x, camera_y = 0.0, 0.0
    player_min_x, player_min_y = nil, nil
    player_max_x, player_max_y = nil, nil
    @players.each do |player_control_id, player|
      position = player.get_component(Components::Position)
      camera_x += position.x
      camera_y += position.y 
      
      player_min_x ||= position.next_x
      player_min_x = position.next_x if position.next_x < player_min_x
      
      player_min_y ||= position.next_y
      player_min_y = position.next_y if position.next_y < player_min_y
      
      player_max_x ||= position.next_x
      player_max_x = position.next_x if position.next_x > player_max_x
      
      player_max_y ||= position.next_y
      player_max_y = position.next_y if position.next_y > player_max_y
    end
    
    distance = Gosu.distance player_min_x, player_min_y - $window.height/3.0, player_max_x, player_max_y + $window.height/4.0
    distance = distance - 500.0
    distance = 0.0 if distance < 0.0
    zoom =  0.55 - ((distance)/2000.0)**0.3*0.28
    zoom = 0.27 if zoom < 0.27
    zoom = 1.0 if zoom > 1.0
    
    @camera_filtering += 0.0005
    @camera_filtering = 0.15 if @camera_filtering > 0.15
    @camera.zoom += (zoom-@camera.zoom)*@camera_filtering
    camera_x /= @players.size
    camera_y /= @players.size
    
    @camera.x += (camera_x-@camera.x)*@camera_filtering
    @camera.y += (camera_y-@camera.y)*@camera_filtering 
    
    
    @background_camera.x = @camera.x
    @background_camera.y = @camera.y
    @background_camera.zoom = @camera.zoom + 0.9
    @background.update @background_camera
    
    
    
    Shaders.haze[:time] = @time
    Systems::Movement.update @entity_manager, @time
    @level.update
  end
  
  def update_replay time
    shared_update time
    @players.each do |player_control_id, player|
      player.update @time
    end
  end
  
  def update_game_logic time
    shared_update time
    Systems::HitTest.update @entity_manager, @characters
    
    @characters.values.each do |character|
      position = character.get_component(Components::Position)
      if position.y > 4000
        $window.reset_stage
      end
    end
    
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
    #$window.fill 0xFF557BC6, 0xFF4F91ED
    @background.draw
    #$window.scale 0.32, 0.32, -100, -50 do
    #$window.scale 0.45, 0.45, $window.width/2, $window.height/2 do
      #$window.translate -position.x+$window.width/2, -position.y+$window.height/3*2 do          
        @level.draw @camera
        Systems::Sprite.draw @entity_manager, @camera
        #Systems::HitTest.draw @entity_manager # for some reason this stops $window.blur from working
        #end
    #end
    
    unless live?
      if $window.button_down? Gosu::KbSpace
        @font.draw "REPLAY <<", 10, 10, 0
      else
        @font.draw "REPLAY >>", 10, 10, 0
      end
    end
    
  end
end