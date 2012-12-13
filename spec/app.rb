#require './crawler'
File.expand_path('./crawler', File.dirname(__FILE__))

class Application



  def call(env)
    request(Rack::Request.new(env))
    response(Rack::Response.new)
  end


  def request(env)
    @env = env
  end


  def response(resp)
    resp['Content-Type'] = 'text/html'
    resp.write '<html><head></head><body>'
    resp.write '<form action="/" method="post">
                  <input type="text" name="url" size="50" value="http://technica.org.ua/">
                  <input type="text" name="hop" size="3" value="3">
                  <input type="submit" value="OK">
                </form>'
    resp.write link
    resp.write '</body></html>'
    resp.finish
  end


  def link
    if @env.post?
      crawler([@env.params["url"]], Integer(@env.params["hop"]))
    elsif @env.get?
      l = 'get'
    end
  end


  def crawler(url, hop)
    crawler = Crawler.new
    crawler.parser(url, hop)
    crawler.all_link.map { |url| "<a href='#{url.to_s}' target='blank'>#{url}</a>" }.join('<br>')
  end


end
