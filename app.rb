require 'rubygems'
require "slack-ruby-client"
require 'json'
require 'sinatra'
require 'mongoid'

require './lib/score'
require './lib/user'

configure do
	Mongoid.load!('./mongoid.yml')
end


get '/' do
	Slack.configure do |config|
	  config.token = "xoxb-11404662370-wWxE6Kd5mEwFNzFDngexHsAK"
	end

	client = Slack::RealTime::Client.new

	client.on :hello do
	  puts "Successfully connected, welcome '#{client.self['name']}' to the '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com."
	end

	client.on :message do |data|

		#p data

		case data['text']
		when 'Hola' then
		client.message channel: data['channel'], text: "Hola <@#{data['user']}>!"
		when 'Hola mi bebe' then
		client.message channel: data['channel'], text: "Hola papi <@#{data['user']}>!"
		when /^[1-5]$/ then
			score = Score.new
			score.value = data['text']
			score.user_id = data['user']
			score.timestamp = Time.now
			if score.save
				p "OK"
			else
				p "ERROR SCORE #{data['user']} - #{Time.now}"
			end
			client.message channel: data['channel'], text: "Gracias <@#{data['user']}>! He recolectado tu happiness index de hoy."
		else
			p "MENSAJE NO MAPEADO: #{data['text']}"
		end
	end

	client.start!
end

get '/get-happiness' do
	Slack.configure do |config|
	  config.token = "xoxb-11404662370-wWxE6Kd5mEwFNzFDngexHsAK"
	end

	client = Slack::Web::Client.new

	#p client.users_list

	client.im_list['ims'].each do |im|
		client.chat_postMessage(channel: im['id'], text: '¿Cómo estás hoy? (Del 1 al 5)', as_user: true)
	end

	#client.chat_postMessage(channel: 'D0BBQ0Z5J', text: '¿Cómo estás hoy? (Del 1 al 5)', as_user: true)
end

get '/sync-users' do

	Slack.configure do |config|
	  config.token = "xoxb-11404662370-wWxE6Kd5mEwFNzFDngexHsAK"
	end

	client = Slack::Web::Client.new

	client.users_list['members'].each do |member|
		unless member['deleted']
			user = User.new
			user.id = member['id']
			user.real_name = member['real_name']
			user.photo = member['profile']['image_192']

			if user.upsert	
				p "OK"
			else
				p "ERROR USER #{member['id']} - #{Time.now}"
			end
		end		
	end

end	

get '/dashboard' do

	@users = User.all

=begin
	hhiroshi_score = 0
	hhiroshi_counter = 0

	gustavo_score = 0
	gustavo_counter = 0

	snahider_score = 0
	snahider_counter = 0

	jessy_score = 0
	jessy_counter = 0

	#U02GBG3PJ gus
	#U02GAHTFT snahider
	#U096S6KMM jessy

	Score.all.each do |score_item|

		if score_item.user_id == "U02GAHMCZ"
			hhiroshi_score += score_item.value.to_i
			hhiroshi_counter += 1
		elsif score_item.user_id == "U02GBG3PJ"
			gustavo_score += score_item.value.to_i
			gustavo_counter += 1
		elsif score_item.user_id == "U02GAHTFT"
			snahider_score += score_item.value.to_i
			snahider_counter += 1
		elsif score_item.user_id == "U096S6KMM"
			jessy_score += score_item.value.to_i
			jessy_counter += 1	
		end

	end

	@hhiroshi_happiness_index =  (hhiroshi_score/hhiroshi_counter.to_f).round(2) unless hhiroshi_counter==0
	@gustavo_happiness_index =  (gustavo_score/gustavo_counter.to_f).round(2) unless gustavo_counter==0
	@snahider_happiness_index =  (snahider_score/snahider_counter.to_f).round(2) unless snahider_counter==0
	@jessy_happiness_index =  (jessy_score/jessy_counter.to_f).round(2) unless jessy_counter==0
=end
	erb :dashboard

end