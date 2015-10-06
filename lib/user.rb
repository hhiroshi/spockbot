require 'mongoid'
require './lib/score'

class User
  include Mongoid::Document
  field :id,        type: String
  field :real_name,  type: String
  field :photo,     type: String
  field :is_bot,     type: Boolean
  
  def happiness_index 
  	
  	score = 0
  	counter = 0
  	happiness_index = 0

  	Score.where(user_id: id).each do |score_item|
		score += score_item.value.to_i
		counter += 1
	end

	happiness_index =  (score/counter.to_f).round(2) unless counter==0
	happiness_index = 5.0 if is_bot

	happiness_index

  end



end
