require 'simplecov'
SimpleCov.start do
  add_filter 'spec/spec_helper'
  add_filter 'lib/endpoint_base.rb'
  coverage_dir 'coverage/sinatra'
end

require File.join(File.dirname(__FILE__), '../spec_helper')
require 'rubygems'
require 'bundler'
require 'vcr'
require 'json'
require 'sinatra'

Bundler.require(:default, :test)
require 'rack/test'

require File.join(File.dirname(__FILE__), '../..', 'lib', 'endpoint_base', 'sinatra', 'base.rb')

Sinatra::Base.environment = 'test'

def app
  TestEndpoint
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

ENV['ENDPOINT_KEY'] = 'x123'

class TestEndpoint < EndpointBase::Sinatra::Base

  set :logging, true

  post '/' do
    process_result 200
  end

  post '/payload' do
    add_value :payload, @message[:payload]

    process_result 200
  end

  post '/deprecated' do
    process_result 200, @message
  end

  post '/config' do
    add_value :params, @config

    process_result 200
  end
end
