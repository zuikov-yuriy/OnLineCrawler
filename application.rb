require './crawler'
File.expand_path('./crawler', File.dirname(__FILE__))

class Application

   attr_reader :req
  def call(env)
    @env = env
    @req = Rack::Request.new(env)
    response(Rack::Response.new)
  end

  #def met
  #  @env["request_method"]
  #end

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
    if @req.request_method["POST"]
      crawler([@req.params["url"]], Integer(@req.params["hop"]))
    elsif @req.request_method["GET"]
      @req.request_method + '--------------' +@req.inspect
    end
  end


  def crawler(url, hop)
    crawler = Crawler.new
    crawler.parser(url, hop)
    crawler.all_link.map { |url| "<a href='#{url.to_s}' target='blank'>#{url}</a>" }.join('<br>')
  end


end
