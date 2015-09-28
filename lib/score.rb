require 'mongoid'

class Score
  include Mongoid::Document
  field :value
  field :user_id
  field :timestamp
end
