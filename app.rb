require 'rubygems'
require "slack-ruby-client"
require 'json'
require 'sinatra'

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

	client = Slack::RealTime::Client.new

	client.chat_postMessage(channel: general_channel['@hhiroshi'], text: '¿Cómo estás hoy? :D', as_user: false)
	client.chat_postMessage(channel: general_channel['@snahider'], text: '¿Cómo estás hoy? :D', as_user: false)
	client.chat_postMessage(channel: general_channel['@jessy.robles'], text: '¿Cómo estás hoy? :D', as_user: false)
	client.chat_postMessage(channel: general_channel['@gustavo.quiroz'], text: '¿Cómo estás hoy? :D', as_user: false)


end