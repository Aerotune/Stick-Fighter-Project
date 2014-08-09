module Characters::Stick1V2::States
  Dir[File.join(File.dirname(__FILE__), *%w[states *.rb])].each { |file| require file }
end