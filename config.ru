require './application'
require './crawler'


use Rack::Reloader
use Rack::CommonLogger
use Rack::Builder


map '/' do
 run Application.new
end

map '/next' do
end
