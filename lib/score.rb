require 'mongoid'

class Score
  include Mongoid::Document
  field :value,   type: String
  field :user_id,   type: String
  field :timestamp,   type: Time
end
