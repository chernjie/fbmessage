require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'fileutils'
require 'open3'
require 'uri'
require 'rubygems'
require 'json'
require 'yaml'
require 'rest_client'
require 'cpf_faker'
require 'pry'
require 'cgi'
require 'rye'
require 'timeout'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'uri'
require 'net/http' 
# require './drivers/firefox.rb'

http = Net::HTTP.new(@host, @port)
http.read_timeout = 500
seed = YAML.load(@seed_data)

feature "Greetings", js: true do
	scenario "As a boyfriend, I want to wish" do
		visit seed["url"]
		fill_in "email", with: seed["email"]
		fill_in "pass", with: seed["password"]
		click_button "Log In"
		fill_in "message_body", with: seed["message_body"]
		find('textarea[name="message_body"]').native.send_keys(:return)
	end
end
