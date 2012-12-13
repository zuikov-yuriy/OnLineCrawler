require 'spec_helper'
require 'rack'
require 'rack/mock'
require 'rack/request'
require 'rack/response'


describe Application do


  describe "" do

    it "" do

      env = Rack::MockRequest.env_for("/", :method => "get",)

      a = Application.new
      a.call(env)
      a.req

    end


  end





end
