module Characters::Stick1V2::AnimationStates
  Dir[File.join(File.dirname(__FILE__), *%w[animation_states *.rb])].each { |file| require file }
end