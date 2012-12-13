require 'nokogiri'  
require 'net/http'
require 'uri'

class Crawler2

  attr_accessor :link, :hop, :href_array, :href, :i, :lvl, :doc

  def initialize(link, hop)
    @link = link
    @hop = hop
    @href_array = []
    @href =[]
    @i = 0
    @lvl = true
    @url = []
  end

  def page
    uri = URI(@link)
    Net::HTTP.get_response(uri)
  end


  def write
    @url << @href
  end


  def show
    if @i == @hop
      @url
    else
      if @link != nil
        uri = URI(@link);
        doc = Nokogiri::HTML(self.page.body)
        doc.search('//a').each do |a|
        href = a["href"];
          if (href) &&  (!href.match(/^#/))
            if  (href) && (!href.match(/^http?:/))
              @href_array << "http://" + uri.host + String(href);
              else
              @href_array << href;
            end
          end
        end
      end

      if @lvl == true
        @href = @href_array
        self.write
        @href_array = []
        self.array
      end
    end

  end



  def array
    @href.each do |l|
    @link = l
    @lvl = false
    self.show
  end
    @link = nil
    @lvl = true
    @i += 1
    self.show
  end


end

































def write(lvl_link)
  File.open('link', 'a'){ |file| file.write "#{lvl_link} \n\n\n"}
  #self.write(lvl_link)
end















#require './crawler'

File.expand_path('./crawler', File.dirname(__FILE__))
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
