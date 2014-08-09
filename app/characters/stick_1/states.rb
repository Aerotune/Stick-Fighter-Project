module Characters::Stick1::States
  Dir[File.join(File.dirname(__FILE__), *%w[states *.rb])].each { |file| require file }
end