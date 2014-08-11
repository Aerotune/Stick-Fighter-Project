module Commands
  Dir[File.join(File.dirname(__FILE__), *%w[commands *.rb])].each { |file| require file }
end