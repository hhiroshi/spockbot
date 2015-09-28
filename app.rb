require 'rubygems'
require "slack-ruby-client"
require 'json'
require 'sinatra'
require 'mongoid'

require './lib/score'

configure do
	Mongoid.configure do |config|
    	config.sessions = { 
			:default => { :hosts => ["localhost:27017"], :database => "spockbot"}
		}
	end
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
	  case data['text']
	  when 'Hola' then
	    client.message channel: data['channel'], text: "Hola <@#{data['user']}>!"
	  when 'Hola mi bebe' then
	    client.message channel: data['channel'], text: "Hola papi <@#{data['user']}>!"
	  when /[1-5]/ then
	  	score = Score.new
	  	score.attributes {value:data, user_id:"1", timestamp:Time.now}
	  	score.save
	    client.message channel: data['channel'], text: "Gracias <@#{data['user']}>!"
	  when /^bot/ then
	    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
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

	#client.im_list['ims'].each do |im|
	#	client.chat_postMessage(channel: im['id'], text: '¿Cómo estás hoy? :D', as_user: true)
	#end

	client.chat_postMessage(channel: 'D0BBQ0Z5J', text: '¿Cómo estás hoy? :smile:', as_user: true)


end