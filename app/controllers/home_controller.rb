require "date"
require "net/http"
require "uri"
require "json"

class HomeController < ApplicationController
    def index
        key = "u8UqpwDnLxodjJPcJwDpK8ODsOmUCBHpUaUrTcIXH3DTXt%2BFp1EKmR%2FB7dReTT9XyqaBZQkwUZMvBMCsLGc2IQ%3D%3D"
        url = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH&pageNo=1&numOfRows=1&ServiceKey="+key+"&_returnType=json"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        dust = JSON.parse(response)
        @dustValue = dust["list"][0]["seoul"]
        
        
        
        @settingLocation = params[:id]
        @mylocation = params[:id]
        if @mylocation == "강원도" 
          lat = 38.25
          lon = 128.56
          @dustValue = dust["list"][0]["gangwon"]
        elsif @mylocation == "경기도"
          lat = 37.692438
          lon = 126.784607
          @dustValue = dust["list"][0]["gyeonggi"]
        elsif @mylocation == "경상남도"
          lat = 35.30
          lon = 128.62
          @dustValue = dust["list"][0]["gyeongnam"]
        elsif @mylocation == "경상북도"
          lat = 36.09
          lon = 129.38
          @dustValue = dust["list"][0]["gyeongbuk"]
        elsif @mylocation == "광주광역시"
          lat = 35.143559
          lon = 126.839677
          @dustValue = dust["list"][0]["gwangju"]
        elsif @mylocation == "대구광역시"
          lat = 35.862976
          lon = 128.595527
          @dustValue = dust["list"][0]["daegu"]
        elsif @mylocation == "대전광역시"
          lat = 36.342051
          lon = 127.405268
          @dustValue = dust["list"][0]["daejeon"]
        elsif @mylocation == "부산광역시"
          lat = 35.159879
          lon = 129.063548
          @dustValue = dust["list"][0]["busan"]
        elsif @mylocation == "서울특별시"
          lat = 37.541350
          lon = 127.010257
          @dustValue = dust["list"][0]["seoul"]
        elsif @mylocation == "세종특별자치시"
          lat = 36.574151
          lon = 127.288521
          @dustValue = dust["list"][0]["sejong"]
        elsif @mylocation == "울산광역시"
          lat = 35.5826 
          lon = 129.3344
          @dustValue = dust["list"][0]["ulsan"]
        elsif @mylocation == "인천광역시"
          lat = 37.96611 
          lon = 124.63046
          @dustValue = dust["list"][0]["incheon"]
        elsif @mylocation == "전라남도"
          lat = 34.81689 
          lon = 126.38121
          @dustValue = dust["list"][0]["jeonnam"]
        elsif @mylocation == "전라북도"
          lat = 
          lon =
          @dustValue = dust["list"][0]["jeonbuk"]
        elsif @mylocation == "제주특별자치도"
          lat = 33.38678
          lon =  126.88021
          @dustValue = dust["list"][0]["jeju"]
        elsif @mylocation == "충청남도"
          lat = 36.80 
          lon = 127.15
          @dustValue = dust["list"][0]["chungnam"]
        elsif @mylocation == "충청북도"
          lat = 36.64
          lon = 127.48
          @dustValue = dust["list"][0]["chungbuk"]
        else
          lat = 37.53
          lon = 126.96
          
          @mylocation = "서울특별시"

          @dustValue = dust["list"][0]["seoul"]
        end
        
        if @dustValue.to_i >= 151
          @dustGrade = "매우 나쁨"
        elsif @dustValue.to_i >= 81
          @dustGrade = "나쁨"
        elsif @dustValue.to_i >= 31
          @dustGrade = "보통"
        else
          @dustGrade = "좋음"
        end
        forecast = forecast = ForecastIO.forecast(lat, lon, params: { units: 'si' })
        #forecast = forecast = ForecastIO.forecast(37.56, 126.97, params: { units: 'si' })
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

                #wind speed
        ws = @currentData.windSpeed
        ws_ok = 4 #수정해야 함!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        #날씨 정보 처리
        high = @data[0].temperatureMax.to_i
        low = @data[0].temperatureMin.to_i

        #
        
        #>>> high & low 조절 ( -2 <= 더위단계 <=2 )
        #high = high + (더위단계*2)
        #low  = low  + (더위단계*2) 
        

        #=======================================outer==========================================
        #1
        if low<-6
            @outer_O = ['패딩', '돕바', '롱패딩']
            @outer_X = ['항공점퍼', '가죽자켓', '트렌치코트', '패딩조끼', '야상', '야구잠바(누빔X)', '후드집업', '청자켓/자켓','얇은 가디건','가디건','두꺼운 가디건','후리스']
            @outer_Tm = []
            @outer_Tp = ['무스탕', '겨울코트', '야구잠바(누빔O)', '방한내피(깔깔이)']
            if high < 5
              @ment = "개추움"
            end
        #2
        elsif -6 <= low and low < 0
          #2-1
          if high<5
            @outer_O = ['패딩', '돕바', '롱패딩']
            @outer_Tp = ['무스탕', '겨울코트', '야구잠바(누빔O)', '방한내피(깔깔이)']
            @outer_Tm = []
            @outer_X = ['항공점퍼', '가죽자켓', '트렌치코트', '패딩조끼', '야상', '야구잠바(누빔X)', '후드집업', '청자켓/자켓', '얇은 가디건', '가디건', '두꺼운 가디건', '후리스']
          #2-2
          elsif 5<=high<12
            @outer_O = ['무스탕', '패딩', '야구잠바 (누빔O)', '돕바', '롱패딩']
            @outer_Tp = ['가죽자켓', '겨울코트', '패딩조끼', '야상', '방한내피(깔깔이)', '두꺼운 가디건', '후리스']
            @outer_Tm = []
            @outer_X = ['항공점퍼', '트렌치코트', '야구잠바(누빔X)', '후드집업', '청자켓/자켓', '얇은 가디건', '가디건']
          #2-3
          elsif 12<=high
            @outer_O = ['무스탕', '겨울코트', '야구잠바(누빔X)']
            @outer_Tp = ['가죽자켓', '패딩조끼', '야상', '방한내피(깔깔이)', '두꺼운 가디건', '후리스']
            @outer_Tm = ['패딩', '돕바', '롱패딩']
            @outer_X = ['항공점퍼', '트렌치코트', '야구잠바(누빔X)', '후드집업', '청자켓/자켓', '얇은 가디건', '두꺼운 가디건']
          end
        #3
        elsif low<5
          #3-1
          if high<12
            @outer_O = ['무스탕', '겨울코트', '야구잠바(누빔O)']
            @outer_Tp = ['가죽자켓', '패딩조끼', '야상', '방한내피(깔깔이)', '두꺼운 가디건', '후리스']
            @outer_Tm = ['패딩', '돕바', '롱패딩']
            @outer_X = ['항공점퍼', '트렌치코트', '야구잠바(누빔X)', '후드집업', '청자켓/자켓', '얇은 가디건', '두꺼운 가디건']
          #3-2
          else
            @outer_O = ['무스탕', '겨울코트', '야구잠바(누빔O)', '방한내피(깔깔이)']
            @outer_Tp = ['가죽자켓', '트렌치코트', '패딩조끼', '야상']
            @outer_Tm = []
            @outer_X = ['항공점퍼', '패딩', '야구잠바(누빔X)', '돕바', '후드집업', '청자켓/자켓', '얇은 가디건', '가디건', '두꺼운 가디건', '후리스', '롱패딩']
          end
        #4
        elsif low <5
          #4-1
          if high<8
            @outer_O = ['무스탕', '겨울코트', '야구잠바(누빔O)']
            @outer_Tp = ['가죽자켓', '패딩조끼', '야상', '방한내피(깔깔이)', '두꺼운 가디건', '후리스']
            @outer_Tm = ['패딩', '돕바', '롱패딩']
            @outer_X = ['항공점퍼', '트렌치코트', '야구잠바(누빔X)', '후드집업', '청자켓/자켓','얇은 가디건','가디건']
          #4-2
          elsif high <10
            @outer_O = ['무스탕','겨울코트','야구잠바(누빔O)','방한내피(깔깔이)']
            @outer_Tp = ['가죽자켓', '트렌치코트', '패딩조끼', '야상']
            @outer_Tm = []
            @outer_X = ['항공점퍼','패딩','야구잠바(누빔X)','돕바','후드집업','청자켓/자켓','얇은 가디건','가디건',
            '두꺼운 가디건','후리스','롱패딩']
          #4-3
          elsif high <20
            @outer_O = ['항공점퍼','트렌치코트','패딩조끼','야구잠바(누빔X)','후드집업','청자켓/자켓','가디건']
            @outer_Tp = []
            @outer_Tm = ['가죽자켓','야상','방한내피(깔깔이)','두꺼운 가디건','후리스']
            @outer_X = ['무스탕','겨울코트','패딩','야구잠바(누빔O)','돕바','얇은 가디건','롱패딩']
          #4-4
          else
            @outer_O = ['항공점퍼','트렌치코트','야구잠바(누빔X)','후드집업','청자켓/자켓','얇은 가디건','가디건']
            @outer_Tp = []
            @outer_Tm = []
            @outer_X = ['가죽자켓','무스탕','겨울코트','패딩조끼','야상','패딩','야구잠바 (누빔O)','방한내피 (깔깔이)','돕바',
            '두꺼운 가디건','후리스','롱패딩']
          end
        #5
        elsif low<20
          @outer_O = ['얇은 가디건']
          @outer_Tp = []
          @outer_Tm = ['항공점퍼', '트렌치코트', '야구잠바(누빔X)', '후드집업', '청자켓/자켓', '가디건']
          @outer_X = ['가죽자켓','무스탕','겨울코트','패딩조끼','야상','패딩','야구잠바 (누빔O)','방한내피 (깔깔이)','돕바',
          '두꺼운 가디건','후리스','롱패딩']
        #6
        else
          @outer_O = ['얇은 가디건']
          @outer_X = ['항공점퍼','가죽자켓','무스탕','트렌치코트','겨울코트','패딩조끼','야상','패딩','야구잠바(누빔X)','야구잠바 (누빔O)',
          '방한내피 (깔깔이)','돕바','후드집업','청자켓/자켓','가디건','두꺼운 가디건','후리스','롱패딩']
          @outer_Tm =[]
          @outer_Tp = []
        end
        
        
        #============================= bottom ================================
        #하의 (스커트(테니스,플리츠,플레어) -> 바람따라 )
        #1
        if low <- 6
          if high < 5
            @bottom_O = []
            @bottom_X = ['3부 바지', '5부 바지', '긴바지 (면)', '팬츠/스커트(린넨)','팬츠(청)','팬츠(생지)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹','검정스타킹']
            @bottom_Tp = ['팬츠/스커트(기모)', '슬랙스(기모O)', '레깅스/치마레깅스(기모O)', '기모스타킹']
            @bottom_Tm = [ ]
          else
            @bottom_O = ['팬츠/스커트(기모O)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)', '기모스타킹']
            @bottom_Tp = ['팬츠(생지)']
            @bottom_X = ['3부 바지','5부 바지','긴바지 (면)','팬츠/스커트(린넨)','팬츠(청)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹','검정스타킹']
          end
        #2
        elsif -6 <= low and low < 0
          if high < 5
            @bottom_O = ['팬츠/스커트(기모O)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)', '기모스타킹']
            @bottom_Tp = ['팬츠(생지)']
            @bottom_Tm = []
            @bottom_X = ['3부 바지','5부 바지','긴바지 (면)','팬츠/스커트(린넨)','팬츠(청)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹','검정스타킹']
          elsif 5 <= high < 12
            @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)','검정스타킹', '기모스타킹']
            @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹']
            @bottom_Tp = []
            @bottom_Tm = []
          elsif 12 <= high
            @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)','검정스타킹', '기모스타킹']
            @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹']
            @bottom_Tp = []
            @bottom_Tm = []
          end
        #3
        elsif low < 5
          if high < 12
              @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)','검정스타킹']
              @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹', '기모스타킹']
              @bottom_Tp = []
              @bottom_Tm = []
          else
              @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)','검정스타킹']
              @bottom_Tp = ['살색스타킹']
              @bottom_Tm = []
              @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)', '기모스타킹']
          end
        #4
        elsif low < 15
          if high < 8
              @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)']
              @bottom_Tp = []
              @bottom_Tm = ['검정스타킹']
              @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','살색스타킹', '기모스타킹']
          elsif high < 10
              @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)']
              @bottom_Tp = ['살색스타킹','검정스타킹']
              @bottom_Tm = []
              @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)', '기모스타킹']
          elsif high < 20
              @bottom_O = ['긴바지 (면)','팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)', '슬랙스(기모O)', '레깅스/치마레깅스 (기모O)']
              @bottom_Tp = ['살색스타킹']
              @bottom_Tm = []
              @bottom_X = ['3부 바지','5부 바지','팬츠/스커트(린넨)','슬랙스 (기모X)','레깅스/치마레깅스 (기모X)','검정스타킹', '기모스타킹']
          else
              @bottom_O = ['5부 바지','긴바지 (면)','팬츠(청)','슬랙스 (기모X)', '레깅스/치마레깅스 (기모X)']
              @bottom_Tp = ['3부 바지','팬츠/스커트(린넨)',  '살색스타킹']
              @bottom_Tm = ['팬츠(생지)']
              @bottom_X = ['팬츠/스커트(기모O)','슬랙스(기모O)','레깅스/치마레깅스 (기모O)','검정스타킹', '기모스타킹']
          end
        #5
        elsif low < 20
              @bottom_O = ['3부 바지','5부 바지','긴바지 (면)','팬츠/스커트(린넨)','팬츠(청)','슬랙스 (기모X)', '레깅스/치마레깅스 (기모X)']
              @bottom_Tp = []
              @bottom_Tm = ['팬츠(생지)']
              @bottom_X = ['팬츠/스커트(기모O)','슬랙스(기모O)','레깅스/치마레깅스 (기모O)','살색스타킹','검정스타킹', '기모스타킹']
        #6
        else
              @bottom_O = ['3부 바지','5부 바지','긴바지 (면)','팬츠/스커트(린넨)','슬랙스 (기모X)']
              @bottom_X = ['팬츠/스커트(기모O)','팬츠(청)','팬츠(생지)','슬랙스(기모O)', '레깅스/치마레깅스 (기모X)','레깅스/치마레깅스 (기모O)','살색스타킹','검정스타킹', '기모스타킹']
              @bottom_Tp = []
              @bottom_Tm = []
        end
        
        
        
        
        if !(@bottom_O & ['팬츠/스커트(기모O)','팬츠/스커트(린넨)']).empty?
            if ws > ws_ok
                @bottom_X.push('플레어 스커트')
            else
                @bottom_O.push('플레어 스커트')
            end
        end
       
       
       
       
        #============================= top =================================
        if high<18
          @top_O = ['셔츠/블라우스 (모직)','두꺼운 니트','맨투맨/후드(기모)','터틀넥']
          @top_X = ['셔츠/블라우스','셔츠/블라우스(린넨)','반팔 티셔츠','민소매']
          @top_Tp = ['니트','맨투맨/후드','긴팔 티셔츠']
          @top_Tm = []
        elsif high<23
          @top_O = ['셔츠/블라우스','니트','맨투맨/후드','긴팔 티셔츠']
          @top_X = ['셔츠/블라우스 (모직)','셔츠/블라우스 (린넨)','민소매','두꺼운 니트','맨투맨/후드 (기모)','터틀넥','오프숄더']
          @top_Tp = ['반팔 티셔츠']
          @top_Tm = []
        elsif high<25
          @top_O = ['셔츠/블라우스','반팔 티셔츠','긴팔 티셔츠']
          @top_X = ['셔츠/블라우스(모직)','셔츠/블라우스(린넨)','민소매','니트','두꺼운 니트','맨투맨/후드(기모)','터틀넥','오프숄더']
          @top_Tp = []
          @top_Tm = ['맨투맨/후드']
        elsif high<30
          @top_O = ['셔츠/블라우스','셔츠/블라우스 (린넨)','반팔 티셔츠','오프숄더']
          @top_X = ['셔츠/블라우스 (모직)','두꺼운 니트','니트','맨투맨/후드','맨투맨/후드(기모)','터틀넥']
          @top_Tp = ['민소매']
          @top_Tm = ['긴팔 티셔츠']
        else
          @top_O = ['셔츠/블라우스(모직)','셔츠/블라우스(린넨)','반팔 티셔츠','민소매','오프숄더']
          @top_X = ['셔츠/블라우스','니트','두꺼운 니트','맨투맨/후드','맨투맨/후드(기모)','터틀넥']
          @top_Tp = []
          @top_Tm = []
        end
        
        
        #========================= shoe ==============================
        if low < 3
          @shoes_O = ['운동화','구두','워커','부츠','어그부츠']
          @shoes_X = ['샌들/ 슬리퍼']
          @shoes_Tp = []
          @shoes_Tm = []
        elsif low < 14
          @shoes_O = ['운동화','구두','워커','부츠']
          @shoes_X = ['어그부츠', '샌들/ 슬리퍼']
          @shoes_Tp = []
          @shoes_Tm = []
        elsif low < 20
          @shoes_O = ['운동화','구두']
          @shoes_X = ['어그부츠']
          @shoes_Tp = ['샌들/ 슬리퍼']
          @shoes_Tm = ['워커','부츠']
        else
          @shoes_O = ['구두','운동화','샌들/ 슬리퍼']
          @shoes_X = ['워커','부츠','어그부츠']
          @shoes_Tp = []
          @shoes_Tm = []
        end
      
      

      
      #===============================================================
      #====================== index function ends ====================
        @locationValue = params[:city_id]
        # @person = User.new(region: 1)

    end
   
    
    def weather
      
        key = "u8UqpwDnLxodjJPcJwDpK8ODsOmUCBHpUaUrTcIXH3DTXt%2BFp1EKmR%2FB7dReTT9XyqaBZQkwUZMvBMCsLGc2IQ%3D%3D"
        url = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnMesureLIst?itemCode=PM10&dataGubun=HOUR&searchCondition=MONTH&pageNo=1&numOfRows=1&ServiceKey="+key+"&_returnType=json"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        dust = JSON.parse(response)
        @dustValue = dust["list"][0]["seoul"]
        
        
         #location 
        @mylocation = params[:id]
        if @mylocation == "강원도" 
          lat = 38.25
          lon = 128.56
          @dustValue = dust["list"][0]["gangwon"]
        elsif @mylocation == "경기도"
          lat = 37.692438
          lon = 126.784607
          @dustValue = dust["list"][0]["gyeonggi"]
        elsif @mylocation == "경상남도"
          lat = 35.30
          lon = 128.62
          @dustValue = dust["list"][0]["gyeongnam"]
        elsif @mylocation == "경상북도"
          lat = 36.09
          lon = 129.38
          @dustValue = dust["list"][0]["gyeongbuk"]
        elsif @mylocation == "광주광역시"
          lat = 35.143559
          lon = 126.839677
          @dustValue = dust["list"][0]["gwangju"]
        elsif @mylocation == "대구광역시"
          lat = 35.862976
          lon = 128.595527
          @dustValue = dust["list"][0]["daegu"]
        elsif @mylocation == "대전광역시"
          lat = 36.342051
          lon = 127.405268
          @dustValue = dust["list"][0]["daejeon"]
        elsif @mylocation == "부산광역시"
          lat = 35.159879
          lon = 129.063548
          @dustValue = dust["list"][0]["busan"]
        elsif @mylocation == "서울특별시"
          lat = 37.541350
          lon = 127.010257
          @dustValue = dust["list"][0]["seoul"]
        elsif @mylocation == "세종특별자치시"
          lat = 36.574151
          lon = 127.288521
          @dustValue = dust["list"][0]["sejong"]
        elsif @mylocation == "울산광역시"
          lat = 35.5826 
          lon = 129.3344
          @dustValue = dust["list"][0]["ulsan"]
        elsif @mylocation == "인천광역시"
          lat = 37.96611 
          lon = 124.63046
          @dustValue = dust["list"][0]["incheon"]
        elsif @mylocation == "전라남도"
          lat = 34.81689 
          lon = 126.38121
          @dustValue = dust["list"][0]["jeonnam"]
        elsif @mylocation == "전라북도"
          lat = 
          lon =
          @dustValue = dust["list"][0]["jeonbuk"]
        elsif @mylocation == "제주특별자치도"
          lat = 33.38678
          lon =  126.88021
          @dustValue = dust["list"][0]["jeju"]
        elsif @mylocation == "충청남도"
          lat = 36.80 
          lon = 127.15
          @dustValue = dust["list"][0]["chungnam"]
        elsif @mylocation == "충청북도"
          lat = 36.64
          lon = 127.48
          @dustValue = dust["list"][0]["chungbuk"]
        else
          lat = 37.53
          lon = 126.96
          
          @mylocation = "서울특별시"
        end
      
        forecast = forecast = ForecastIO.forecast(lat, lon, params: { units: 'si' })
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
        
       
          
          #미세먼지 등급
          
          
        if @dustValue.to_i >= 151
          @dustGrade = "매우 나쁨"
        elsif @dustValue.to_i >= 81
          @dustGrade = "나쁨"
        elsif @dustValue.to_i >= 31
          @dustGrade = "보통"
        else
          @dustGrade = "좋음"
        end
        
    end
    
    def setting
      before_action :authenticate_user!
    end
    
  
end