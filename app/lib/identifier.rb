require 'securerandom'

module Identifier
  def self.create_id
    SecureRandom.base64(12)
  end
end