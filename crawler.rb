require 'nokogiri'
require 'net/http'
require 'uri'


class Crawler

  attr_reader :all_link, :array_link, :count

  def initialize()
    @all_link = []          #Ссылки в одном масиве
    @array_link = []        #Ссылки разбиты на масивы
    @count = 0
  end

  def page(url)
    begin
      uri = URI(url)
      Net::HTTP.get_response(uri)
      rescue
    end
  end

  def parser(link, hop)
    unless hop == 0
      href_array = []

      link.each do |url|

          unless url.match(/^http/)
            url = "http://" +  url
          end

          page = self.page(url)

          unless page.nil?

                doc = Nokogiri::HTML(page.body)
                doc.search('//a').each do |a|
                href = a["href"];


                unless href.nil?
                    if href.match(/^[A-z0-9]/) && !href.match(/^http/)
                      href = "http://" + URI(url).host + "/" + href
                    end

                    if href.match(/^\//)
                      href = "http://" + URI(url).host + href
                    end
                end

                unless (@all_link.include?(href) || href.nil? || href.include?('#') || href.include?('mailto:'))
                  @all_link << href
                  href_array << href
                  @count += 1
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
