class Stage::Background
  Dir[File.join(File.dirname(__FILE__), *%w[background *.rb])].each { |file| require file }
  
  def initialize
    @sky_color = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/sky_color.png')
    #@sun = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/sun.png')
    @ground_color = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/ground_color.png')
    LenseFlare.load_images $window, 'resources/graphics/lense_flare/'
    @pyramide_image_1 = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/pyramide_1.png')
    @pyramide_image_2 = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/pyramide_2.png')
    @pyramide_image_3 = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/pyramide_3.png')
    @oasis_image      = Gosu::Image.new($window, 'resources/graphics/map_art/background/processed/oasis.png')
    @dust_image       = Gosu::Image.new($window, 'resources/graphics/map_art/background/raw/dust.png')
    #@dust = Gosu::Image.new($window, 'resources/graphics/map_art/background/raw/dust.png')
    #@cloud = Gosu::Image.new($window, 'resources/graphics/map_art/raw/cloud_1.png')
    #@cloud_x = -@cloud.width/2
    
    #@ground = Stage::Background::Ground.new(0, 0, 0, $window.height - 340, 0.01)
    
    @parallax_images = []
    
    @vanishing_point_x = $window.width.to_f  * 0.5
    @vanishing_point_y = $window.height.to_f * 0.6
    z = ZOrder::BACKGROUND_ELEMENT
    @sun = Stage::Background::Sun.new(0, 0, 820, 165, 0.002)
    @parallax_images << @sun
    @parallax_images << Stage::Background::Ground.new(0, 0, 0, $window.height - 340, 0.01)
    
    
    @parallax_images << Stage::Background::ParallaxImage.new(@pyramide_image_3, 0, $window.height*2,       z, @vanishing_point_x, @vanishing_point_y, 0.0125, 'haze' => 0.75)
    @parallax_images << Stage::Background::ParallaxImage.new(@pyramide_image_2, 8000, $window.height*3,    z, @vanishing_point_x, @vanishing_point_y, 0.03, 'haze' => 0.5)
    @parallax_images << Stage::Background::ParallaxImage.new(@oasis_image,      1000, $window.height*3.5,    z, @vanishing_point_x, @vanishing_point_y, 0.05, 'haze' => 0.2)
    @parallax_images << Stage::Background::ParallaxImage.new(@pyramide_image_1, -4000, $window.height*4.5,   z, @vanishing_point_x, @vanishing_point_y, 0.1)
    @parallax_images << Stage::Background::ParallaxImage.new(@dust_image,        3000, $window.height*5.6, z, @vanishing_point_x, @vanishing_point_y, 0.14, 'velocity_x' => -10)
    @parallax_images.sort! { |a,b| a.z <=> b.z }
  end
  
  def update camera
    @parallax_images.each do |parallax_image|
      parallax_image.update camera
    end
  end
  
  def draw
    @sky_color.draw 0, -70, 0
    
    @parallax_images.each do |parallax_image|
      if parallax_image.respond_to?(:haze) && parallax_image.haze > 0.0
        Shaders.haze[:strength] = parallax_image.haze
        $window.post_process shaders: Shaders.haze, z: parallax_image.z do
          parallax_image.draw
        end
      else
        parallax_image.draw
      end
      
      if parallax_image.class == Stage::Background::Sun
        draw_sun_center_flare @sun.screen_x, @sun.screen_y
      end
    end    
    
    draw_sun_outer_flare @sun.screen_x, @sun.screen_y
    #@sun.draw
    #@ground.draw
    #sun_x = 720 - camera.x#$window.mouse_x#
    #sun_y = 245 - camera.y#$window.mouse_y#
    #@sun.draw_rot sun_x, sun_y, ZOrder::SUN, 0, 0.5, 0.5#, 1, 1, 0xFFFFFFFF, :additive    
    #@ground_color .draw 0, $window.height - 346, ZOrder::BACKGROUND_GROUND
    #draw_flare    sun_x, sun_y
    
  end
  
  def draw_sun_outer_flare x, y
    z = ZOrder::SUNFLARE_OUTER
    center_x = $window.width/2.0
    center_y = $window.height/2.0
    strength = 0.35 + Math.sin(Time.now.to_f*1.6)*0.05 - rand*0.1
    color = Gosu::Color.rgb(255,230,190)
    scale = 1.45
    angle = 0.0
    LenseFlare.draw_outer_flare x, y, z, center_x, center_y, strength, color, scale, angle
  end
  
  def draw_sun_center_flare x, y
    z = ZOrder::SUN
    center_x = $window.width/2.0
    center_y = $window.height/2.0
    strength = 0.4 + Math.sin(Time.now.to_f*1.6)*0.05 - rand*0.11
    color = Gosu::Color.rgb(255,230,190)
    scale = 1.45
    angle = 0.0
    LenseFlare.draw_center_flare x, y, z, center_x, center_y, strength, color, scale, angle
  end
end