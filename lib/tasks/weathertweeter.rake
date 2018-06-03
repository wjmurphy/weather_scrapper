require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'twitter'
 
  
namespace :weathertweeter do
  desc "Import top 100 cities and tweet their current weather"

  task weather_tweeter: :environment do
    puts "one"
    pop_url = "https://www.worldatlas.com/citypops.htm"
    res = Net::HTTP.get_response(URI.parse(pop_url))
    if res.code.to_i >= 200 && res.code.to_i < 400
        
        page = Nokogiri::HTML(open(pop_url))
        
        table = page.at("tbody")
        
        if table != nil
            puts "two"
            table.css('tr').each do |line|
                puts "three"
                country = line.css('td[2]').text.strip
                web_url = "www.wapper.co.uk/search?q=#{country.parameterize}"
                
                url = "https://www.weather-forecast.com/locations/#{ country.parameterize }/forecasts/latest"
                res = Net::HTTP.get_response(URI.parse(url))
                if res.code.to_i >= 200 && res.code.to_i < 400
                    puts "four"
                    page = Nokogiri::HTML(open(url))
                    div = page.at(".b-forecast__table-description")
                    if div != nil
                        puts "five"
                        short = div.search('td').first
                        short_title = short.search('h2')
                        short_summary = short.search('p')
                        @short_title = short_title.text.strip
                        @short_summary = short_summary.text.strip
                        
                    end
                end
                message = "#{@short_title} #{@short_summary} See how the weather is changing here #{web_url} #weather ##{country.parameterize }".truncate(270)
                $twitter.update(message)
            end
        
        end
    end
  end
end