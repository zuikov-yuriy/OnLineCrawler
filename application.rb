require './crawler'

class Application

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    response['Content-Type'] = 'text/html'


    form ='<form action="/" method="post">
            <input type="text" name="url" size="50" value="http://technica.org.ua/">
            <input type="text" name="hop" size="3" value="3">
            <input type="submit" value="OK">
          </form>'

    response.write '<html><head></head><body>'

    if request.post?
      crawler = Crawler.new
      crawler.parser([request.params["url"]], Integer(request.params["hop"]))
      response.write form
      response.write '<div>Count Hop:'  + request.params["hop"] + '</div>'
      response.write '<div>Count Links:'  + crawler.count.to_s + '</div>'
      response.write crawler.all_link.map { |url| "<a href='#{url.to_s}' target='blank'>#{url}</a>" }.join('<br>')
      response.write '<br><br><br>'
      response.write crawler.array_link
    else
      response.write form
    end

    response.write '</body></html>'
    response.finish
  end

end
