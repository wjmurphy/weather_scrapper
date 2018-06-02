require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

class SearchController < ApplicationController
    
    def index
        @location = params[:q].split(' ')
        
        url = "https://www.weather-forecast.com/locations/#{ @location.first }/forecasts/latest"
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
                
                long = div.search('td').last
                long_title = long.search('h2')
                long_summary = long.search('p')
                @long_title = long_title.text.strip
                @long_summary = long_summary.text.strip
            end
        end
        
    end
end
