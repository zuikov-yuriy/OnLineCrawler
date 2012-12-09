require 'nokogiri'
require 'net/http'
require 'uri'


class Crawler

  attr_reader :all_link, :array_link

  def initialize()
    @all_link = []          #Ссылки в одном масиве
    @array_link = []        #Ссылки разбиты на масивы
  end

  def page(url)
    uri = URI(url)
    Net::HTTP.get_response(uri)
  end



  def parser(link, hop)

    if hop != 0

      href_array = []

      link.each do |url|

        unless url.match(/^http/)
          url = "http://" +  url
        end

        unless url.match(/^#/)

        end

        doc = Nokogiri::HTML(self.page(url).body)
        doc.search('//a').each do |a|

          href = a["href"];

        begin

          if href.match(/^[A-z0-9]/) && !href.match(/^http/)
            href = "http://" + URI(url).host + "/" + href
          end

          if href.match(/^\//)
            href = "http://" + URI(url).host + href
          end

          if !href.match(/^\//) && !href.match(/^[A-z0-9]/)
            href = nil
          end

          if href.include?("mailto:")
            href = nil
          end

        rescue
        end



          unless @all_link.include?(href)
            if href != nil
              @all_link << href
              href_array << href
            end
          end

        end

      end

      @array_link << href_array
      hop -= 1
      parser(href_array, hop)

    end




  end





end
