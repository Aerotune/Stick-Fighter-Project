require 'json'

module JSON
  def self.parse_file file_path
    raw_json = IO.read(file_path).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    JSON.parse(raw_json)
  end
end