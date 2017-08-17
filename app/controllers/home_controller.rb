class HomeController < ApplicationController
    def index
        forecast = forecast = ForecastIO.forecast(37.56, 126.97, params: { units: 'si' })
        @currentData = forecast.currently
        @timezone = forecast.timezone
        #@daily = forecast.daily.summary
        @data = forecast.daily.data
        unixTime = forecast.hourly.data[0].time.to_s
        @localTime = DateTime.strptime(unixTime,'%d')
        
        @korHour = Time.now.in_time_zone('Seoul').hour
        @korMin = Time.now.strftime("%M")
        @korMon = Time.now.in_time_zone('Seoul').month
        @korDay = Time.now.in_time_zone('Seoul').day
      
    
        @hourlyData = forecast.hourly.data
   
        
    end
    
    def weather
        forecast = forecast = ForecastIO.forecast(37.56, 126.97, params: { units: 'si' })
        @currentData = forecast.currently
        @timezone = forecast.timezone
        #@daily = forecast.daily.summary
        @data = forecast.daily.data
        
        @korHour = Time.now.in_time_zone('Seoul').hour
        @korMin = Time.now.strftime("%M")
        @korMon = Time.now.in_time_zone('Seoul').month
        @korDay = Time.now.in_time_zone('Seoul').day
        #unixTime = forecast.hourly.data[0].time.to_s
        #@localTime = DateTime.strptime(unixTime,'%s')
        
        #weekly month value
        @todayMon = (Time.now).month
        @tmrMon = (Time.now + (24*60*60)).month
        @thirdMon = (Time.now + (2*24*60*60)).month
        @fourthMon = (Time.now + (3*24*60*60)).month
        @fifthMon = (Time.now + (4*24*60*60)).month
        @sixthMon = (Time.now + (5*24*60*60)).month 
        @afterWeekMon = (Time.now + (6*24*60*60)).month
        
        #weekly day value
        @todayDay = (Time.now).day
        @tmrDay = (Time.now + (24*60*60)).day 
        @thirdDay = (Time.now + (2*24*60*60)).day 
        @fourthDay = (Time.now + (3*24*60*60)).day 
        @fifthDay = (Time.now + (4*24*60*60)).day 
        @sixthDay = (Time.now + (5*24*60*60)).day 
        @afterWeekDay = (Time.now + (6*24*60*60)).day 
        
        
        #weekly 요일 value
        
        
       # 0이 sunday부터 6까지(6은 saturday)
       # 현재 시간을 now에 저장
       now = Time.now.in_time_zone('Seoul')
      
       # 오늘 월/일
       #tmonth = now.strftime("%m") %>
       #tday = now.strftime("%d") %>
       # 요일
       # now = Time.now.in_time_zone('Seoul')
        @todayWeekly = Time.now.strftime("%A")
        @tmrWeekly = (Time.now + (24*60*60)).strftime("%A")
        @thirdWeekly = (Time.now + (2*24*60*60)).strftime("%A")
        @fourthWeekly = (Time.now + (3*24*60*60)).strftime("%A")
        @fifthWeekly = (Time.now + (4*24*60*60)).strftime("%A")
        @sixthWeekly = (Time.now + (5*24*60*60)).strftime("%A")
        @afteroneWeekly = (Time.now + (6*24*60*60)).strftime("%A")
        
        @korMin = Time.now.strftime("%M")
        
        
        
        
       
        @hourlyData = forecast.hourly.data
    end
    
  
end
