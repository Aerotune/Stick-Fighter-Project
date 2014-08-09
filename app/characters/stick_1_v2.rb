class Characters::Stick1V2 < Character
  Dir[File.join(File.dirname(__FILE__), *%w[stick_1_v2 *.rb])].each { |file| require file }
  spritesheets_folder 'resources', 'images', 'stick_1_v2'
end