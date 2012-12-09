require './crawler'

class Application

 def call(env)
  request = Rack::Request.new(env)
  response = Rack::Response.new
  response['Content-Type'] = 'text/html'
	@form ='<html>
		<head>
		</head>
			<body>
				<form action="/" method="post">
					<input type="text" name="url" size="50" value="http://technica.org.ua/">
           <input type="text" name="hop" size="3" value="3">
					<input type="submit" value="OK">
				</form>
			</body>
		</html>'



  if request.post?
    crawler = Crawler.new
    crawler.parser([request.params["url"]], Integer(request.params["hop"]))
    response.write @form
    response.write crawler.all_link.map { |url| " <a href='#{url.to_s}' target='blank' >#{url}</a>" }.join("<br>")
    response.write "<br><br><br>"
    response.write crawler.array_link
    response.finish
  else
    response.write @form
    response.finish
  end

  end

end
