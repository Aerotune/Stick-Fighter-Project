require 'gosu'
require_relative '../app/lib/sprite_sheet'

# drag sprite to match center point
# use arrow keys to move sprite one pixel
# Press tab and shift+tab to switch sheet
# Press S to save
# Press space to move center point

class Window < Gosu::Window
  def initialize
    super 800, 600, false
    $window = self
    @sprite_sheets = {}

    Dir[File.join(File.dirname(__FILE__), *%w[.. resources images stick_1_v2 *.json])].each do |sprite_sheet_path|
      @sprite_sheets[sprite_sheet_path] = SpriteSheet.load(sprite_sheet_path)
    end
    
    @anchor_point_x = 400
    @anchor_point_y = 400
    
    @current_sprite_sheet_index = 0
    @current_sprite_sheet = @sprite_sheets[@sprite_sheets.keys[@current_sprite_sheet_index]]
    @image = @current_sprite_sheet[:images].first
    @image_index = 0
  end
  
  def needs_cursor?
    true
  end
  
  def button_down id
    case id
    when Gosu::MsLeft
      @start_center_x = @current_sprite_sheet[:center_x]
      @start_center_y = @current_sprite_sheet[:center_y]
      @mouse_start_x = mouse_x
      @mouse_start_y = mouse_y
    when Gosu::KbTab
      delta_index = (button_down?(Gosu::KbLeftShift) || button_down?(Gosu::KbRightShift)) ? 1 : -1
      @image_index = 0
      @current_sprite_sheet_index = (@current_sprite_sheet_index - delta_index) % @sprite_sheets.length
      @current_sprite_sheet = @sprite_sheets[@sprite_sheets.keys[@current_sprite_sheet_index]]
    when Gosu::KbRight
      @current_sprite_sheet[:center_x] -= 1
    when Gosu::KbLeft
      @current_sprite_sheet[:center_x] += 1
    when Gosu::KbUp
      @current_sprite_sheet[:center_y] += 1
    when Gosu::KbDown
      @current_sprite_sheet[:center_y] -= 1
    when Gosu::KbS
      @sprite_sheets.each do |sprite_sheet_path, sprite_sheet|
        raw_json = IO.read(sprite_sheet_path).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        json = JSON.parse(raw_json)
        
        json['meta']['center_x'] = sprite_sheet[:center_x]
        json['meta']['center_y'] = sprite_sheet[:center_y]
        p json
        File.open(sprite_sheet_path, 'w') do |file|
          file.write json.to_json
        end        
      end
      puts "saved!"
    end
  end
  
  def update
        
    @image_index = (@image_index + 27.0/60.0) % @current_sprite_sheet[:images].length
    @image = @current_sprite_sheet[:images][@image_index]
    
    if button_down? Gosu::MsLeft
      @current_sprite_sheet[:center_x] = @start_center_x + (@mouse_start_x - mouse_x) 
      @current_sprite_sheet[:center_y] = @start_center_y + (@mouse_start_y - mouse_y)
    elsif button_down? Gosu::KbSpace
      @anchor_point_x = mouse_x
      @anchor_point_y = mouse_y
    end
  end
  
  def draw
    fill 0xFFFFFFFF
    color = 0xFFFF0000
    
    radius = 5
    draw_quad \
      @anchor_point_x-radius, @anchor_point_y-radius, color,
      @anchor_point_x-radius, @anchor_point_y+radius, color,
      @anchor_point_x+radius, @anchor_point_y+radius, color, 
      @anchor_point_x+radius, @anchor_point_y-radius, color 
    
    @image.draw @anchor_point_x-@current_sprite_sheet[:center_x],@anchor_point_y-@current_sprite_sheet[:center_y],0
  end
  
  def fill c1, c2=c1, c3=c2, c4=c3
    x1 = 0
    y1 = 0
    
    x2 = width
    y2 = 0
    
    x3 = width
    y3 = height
    
    x4 = 0
    y4 = height
    
    $window.draw_quad x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4
  end
end

Window.new.show