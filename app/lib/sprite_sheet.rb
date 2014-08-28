require_relative 'json'

module SpriteSheet
  def self.load sprite_sheet_path
    raw = JSON.parse_file(sprite_sheet_path)
    image_path = File.join File.dirname(sprite_sheet_path), raw['meta']['image']
    name = File.basename image_path, '.png'
    
    spritesheet = Gosu::Image.new $window, image_path, true
    
    image_info = {
      'name' => name,
      'frames' => [],
      'center_x' => raw['meta']['center_x'].to_f,
      'center_y' => raw['meta']['center_y'].to_f
    }
    
    raw['frames'].each do |raw_frame|
      f = raw_frame['frame']
      source_size = raw_frame['spriteSourceSize']
      frame = {}
      
      image = spritesheet.subimage(f['x'], f['y'], f['w'], f['h'])
      warn "#{image_path} is slow at loading! try making it a 1024x1024 spritesheet" unless image
      image ||= Gosu::Image.new $window, spritesheet, true, f['x'], f['y'], f['w'], f['h']
      
      frame['image'] = image
      frame['offset_x'] = source_size['x']
      frame['offset_y'] = source_size['y']
      image_info["frames"] << frame
    end
    
    image_info
  end  
end