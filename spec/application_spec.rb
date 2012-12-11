require 'spec_helper'
require '../crawler'
require 'rack'


describe Application do



  describe "" do
    it "" do

      a = Application.new
      env = Rack::MockRequest.env_for("/", :method => "POST", :input => "url=http://technica.org.ua/",:input => "hop=3")
      a.call(env)
      a.request.params["hop"].should.equal "3"

    end
  end

end
