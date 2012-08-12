require 'rubygems'
require 'json'
require 'net/http'

# api key from wunderground: 7b1e71b12f5535c0
module SimpleWeather
	class Weather
		def initialize
			@last_update = Time.now
			@conditions = {}
		end
		
		def included(base)
			SimpleWeather.configure { |c| nil }
			base.extend ClassMethods
			base.send :include, InstanceMethods
		end

		def updateWeather(city = 'MD/College Park')
			base_url = 'http://api.wunderground.com/api/'
			API_KEY =  '7b1e71b12f5535c0'
			query = '/conditions/q/'
			format = '.json'
			
			url = URI.escape(base_url << api_key << query << city << format)
			res = Net::HTTP.get_response(URI(url))
			data = res.body if res.is_a?(Net::HTTPSuccess)

			@conditions = JSON.parse(data)
			
			if @conditions.has_key? 'error'
				raise 'Web service error'
			end
		end                   
			
		def getImageUrl  
			@conditions['current_observation']['icon_url'] 
		end	
		
		def getWeather
			@conditions['current_observation']['weather']
		end
		
		def getTemp_f
			@conditions['current_observation']['temp_f']
		end
		
		def getTemp_c
			@conditions['current_observation']['temp_c']
		end
		
		def getFeelsLike
			@conditions['current_observation']['fellslike_string']
		end
	end
end

ActionView::Base.send(:include, SimpleWeather) if defined?(ActionView::Base)
