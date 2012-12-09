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