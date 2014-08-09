require 'json'

module SpriteSheet
  def self.load sprite_sheet_path
    raw_json = IO.read(sprite_sheet_path).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    #raise "RAW: #{raw.inspect}"
    #raw[0] = '' if raw[0] == "﻿"
    #raw[] = ''
    raw = JSON.parse(raw_json)
    image_path = File.join File.dirname(sprite_sheet_path), raw['meta']['image']
    name = File.basename image_path, '.png'
    
    
    spritesheet = Gosu::Image.new $window, image_path, true
    
    #w = raw['frames'][0]['frame']['w']
    #h = raw['frames'][0]['frame']['h']
    #center_x = raw['meta']['center_x'] ? raw['meta']['center_x'] / w : 0.5
    #center_y = raw['meta']['center_y'] ? raw['meta']['center_y'] / h : 1.0
    
    image_info = {
      'name' => name,
      'images' => [],
      'center_x' => raw['meta']['center_x'].to_f,
      'center_y' => raw['meta']['center_y'].to_f
    }
    
    raw['frames'].each do |frame|
      f = frame['frame']
      image = spritesheet.subimage(f['x'], f['y'], f['w'], f['h'])
      warn "#{image_path} is slow at loading! try making it a 1024x1024 spritesheet" unless image
      image ||= Gosu::Image.new $window, spritesheet, true, f['x'], f['y'], f['w'], f['h']
      image_info["images"] << image
    end
    
    image_info
  end
  
  
end