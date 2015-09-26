require 'rubygems'
require "slack-ruby-client"
require 'json'
require 'sinatra'

get '/' do
	Slack.configure do |config|
	  config.token = "xoxb-11404662370-wWxE6Kd5mEwFNzFDngexHsAK"
	end

	client = Slack::Web::Client.new
	client.auth_test
	general_channel = client.channels_list['channels'].detect { |c| c['name'] == 'random' }
	client.chat_postMessage(channel: general_channel['id'], text: 'Jessy vas a jalar! #friendzone', as_user: true)
end

get 'realtime' do

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self['name']}' to the '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com."
end

client.on :message do |data|
  case data['text']
  when 'bot hi' then
    client.message channel: data['channel'], text: "Hi <@#{data['user']}>!"
  when /^bot/ then
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
  end
end

client.start!

end

