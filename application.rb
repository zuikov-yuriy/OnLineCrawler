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
					<input type="text" name="url" size="50" value="http://web-catalog.org.ua/crawler/start.php">
                                        <input type="text" name="hop" size="3" value="3">
					<input type="submit" value="OK">
				</form>
			</body>
		</html>'

	

	if request.post?
                crawler = Crawler.new(request.params["url"], Integer(request.params["hop"]))
                response.write @form
		response.write crawler.show
		response.finish 
	else
		response.write @form
		response.finish
	end

  end

end
