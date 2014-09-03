module Characters::Stick1V2::ControllerStates
  Dir[File.join(File.dirname(__FILE__), *%w[controller_states *.rb])].each { |file| require file }
end