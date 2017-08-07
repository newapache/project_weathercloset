class HomeController < ApplicationController
    def index
        forecast = forecast = ForecastIO.forecast(37.56, 126.97, params: { units: 'si' })
        @currentData = forecast.currently
        @timezone = forecast.timezone
        #@daily = forecast.daily.summary
        @data = forecast.daily.data
        #unixTime = forecast.hourly.data[0].time.to_s
        #@localTime = DateTime.strptime(unixTime,'%s')
        @korTime = Time.now.in_time_zone("Seoul").hour
        
        @hourlyData = forecast.hourly.data
    end
end
