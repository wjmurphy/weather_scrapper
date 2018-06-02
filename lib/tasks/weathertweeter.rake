require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
  
namespace :weathertweeter do
  desc "Import top 100 cities and tweet their current weather"

  task weather_tweeter: :environment do
    url = "https://www.worldatlas.com/citypops.htm"
    res = Net::HTTP.get_response(URI.parse(url))
    if res.code.to_i >= 200 && res.code.to_i < 400
    page = Nokogiri::HTML(open(url))
    table = page.at("tbody")
        if table != nil
            table.css('tr').first do |line|
                country = line.css('td[2]')
                web_url = "www.wapper.co.uk/search?utf8=✓&q=#{country.text.strip}"
                
                url = "https://www.weather-forecast.com/locations/#{ country.text.strip }/forecasts/latest"
                res = Net::HTTP.get_response(URI.parse(url))
                if res.code.to_i >= 200 && res.code.to_i < 400
                page = Nokogiri::HTML(open(url))
                div = page.at(".b-forecast__table-description")
                    if div != nil
                        short = div.search('td').first
                        short_title = short.search('h2')
                        short_summary = short.search('p')
                        @short_title = short_title.text.strip
                        @short_summary = short_summary.text.strip
                        
                    end
                end
                
                $twitter.update("#{@short_title} #{@short_summary} See how the weather is changing here #{web_url} #weather ##{country.text.strip}")
            end
        
        end
    end
  end
end