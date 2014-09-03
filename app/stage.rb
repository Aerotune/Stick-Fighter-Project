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
    @camera = Camera.new 1350, 900-1000, 0.8
    @background_camera = Camera.new 1350, 900-1000, 0.8
    @background = Stage::Background.new
    @camera_filtering = 0.01
    @background.update @camera
    @level = Stage::Level.new self
    @start_time = nil
    @time = 0
    @live_time = -1 # I kinda need this so I don't get any input before the characters are properly spawned
    
    @font = Gosu::Font.new($window, 'Arial', 16)
    
    @entity_manager = EntityManager.new
    #@time_queue = TimeQueue.new
    
    @players = {}
    @level_objects = []
    
    add_player 'player2', 200, 200-1000, "IdleRight", [0.2, 0.0, 0.4]
    add_player 'player1', 2500, 1600-1000, "IdleLeft", [0.4, 0.05, 0.0]
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
    
    player_min_x, player_min_y = nil, nil
    player_max_x, player_max_y = nil, nil
    
    @players.each do |player_control_id, player|
      position = player.get_component(Components::Position)
      
      player_min_x ||= position.next_x
      player_min_x = position.next_x if position.next_x < player_min_x
      
      player_min_y ||= position.next_y
      player_min_y = position.next_y if position.next_y < player_min_y
      
      player_max_x ||= position.next_x
      player_max_x = position.next_x if position.next_x > player_max_x
      
      player_max_y ||= position.next_y
      player_max_y = position.next_y if position.next_y > player_max_y
    end
    
    player_min_y -= $window.height*1.5
    player_max_y += $window.height/1.5
    
    
    
    camera_x = (player_min_x + player_max_x) / 2.0
    camera_y = (player_min_y + player_max_y) / 2.0
        
    distance = Gosu.distance player_min_x, player_min_y, player_max_x, player_max_y
    distance = distance - 1200.0
    distance = 0.0 if distance < 0.0
    distance = 9000.0 if distance > 6000.0
    zoom_out = ((distance)/16000.0)**0.1 * (1000.0 / $window.width)
    zoom_out = 0.85 if zoom_out > 0.85
    zoom =  1.05 - zoom_out# * 0.9
    #zoom = 0.15 if zoom < 0.15
    #zoom = 1.0 if zoom > 1.0
    
    @camera_filtering += 0.0005
    @camera_filtering = 0.125 if @camera_filtering > 0.125
    camera_delta_zoom = zoom - @camera.zoom
    @camera.zoom += camera_delta_zoom*@camera_filtering
    
    prev_camera_x = @camera.x
    prev_camera_y = @camera.y
    camera_dx = (camera_x-prev_camera_x)
    camera_dy = (camera_y-prev_camera_y)
    camera_speed = Gosu.distance(0,0,camera_dx, camera_dy)
    wind_strength = 0.3+Math.tanh(camera_speed/40.0+camera_delta_zoom)*0.2
    @camera.x += camera_dx*@camera_filtering
    @camera.y += camera_dy*@camera_filtering 
        
    if $shake && Time.now.to_f - $shake < 0.12
      @camera.x += (rand-0.5) * $shake_amount * 0.7
      @camera.y += (rand-0.5) * $shake_amount * 0.7
      @camera.angle += ((rand-0.5) * $shake_amount - @camera.angle) * 0.1
    else
      @camera.angle *= 0.9
    end
    
    SoundResource.play('wind' ,wind_strength, 1.0+wind_strength)
    
    
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
      if position.y > 2000
        $window.reset_stage
      end
    end
    
    @players.each do |player_control_id, player|
      hit_box  = player.get_component Components::HitBox
      position = player.get_component Components::Position
      
      player.hit_level_down = nil
      player.hit_level_up   = nil
      player.hit_level_left = nil
      player.hit_level_right = nil
      
      @level.objects.each do |object|
        left        = position.x      + hit_box.offset_x
        right       = left            + hit_box.width
        top         = position.y      + hit_box.offset_y
        bottom      = top             + hit_box.height
        next_left   = position.next_x + hit_box.offset_x
        next_right  = next_left       + hit_box.width
        next_top    = position.next_y + hit_box.offset_y
        next_bottom = next_top        + hit_box.height
        #height = hit_box.height - hit_box.width/2.0
        
        hit_x = (object.left .. object.right) === position.x
        hit_down = hit_x && (bottom <= object.top) && (next_bottom >= object.top)
        
        #hit_y = (top + hit_box.width/2.0 .. bottom - hit_box.width/2.0).overlaps?(object.top..object.bottom)
        #hit_left  = hit_y && (left >= object.right) && (next_left <= object.right)
        #hit_right = hit_y && (right <= object.left) && (next_right >= object.left)
        if object.solid
          hit_up   = hit_x && (top >= object.bottom) && (next_top <= object.bottom)
          
          object_middle = object.left + object.width/2.0
          hit_y = (top + 50 .. bottom - 50).overlaps?(object.top..object.bottom)
          hit_left  = hit_y && (object_middle..object.right) === next_left
          hit_right = hit_y && (object.left..object_middle) === next_right
        end        
        
        player.hit_level_down = object.top    if hit_down
        player.hit_level_up   = object.bottom if hit_up
        player.hit_level_right = object.left - hit_box.width/2.0  if hit_right
        player.hit_level_left = object.right + hit_box.width/2.0  if hit_left        
      end
      
      
      player.update @time
      player.update_game_logic @time
    end
  end
  
  def draw
    #$window.fill 0xFF557BC6, 0xFF4F91ED
    $window.rotate @camera.angle, $window.width/2.0, $window.height/2.0 do
      @background.draw
      @level.draw @camera
    end
    
    
    Systems::Sprite.draw @entity_manager, @camera
    Systems::HitTest.draw @entity_manager, @camera if $show_hit_boxes # for some reason this stops $window.blur from working
    #$window.blur
    unless live?
      if $window.button_down? Gosu::KbSpace
        @font.draw "REPLAY <<", 10, 10, 0, 1, 1, 0xFF000000
      else
        @font.draw "REPLAY >>", 10, 10, 0, 1, 1, 0xFF000000
      end
    end
    
  end
end