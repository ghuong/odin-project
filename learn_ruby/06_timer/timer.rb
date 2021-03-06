class Timer
	attr_accessor :seconds

	def initialize
		@seconds = 0
	end

	def time_string
		seconds = @seconds
		hours = seconds / (60 * 60)
		seconds -= hours * 60 * 60
		minutes = seconds / 60
		seconds -= minutes * 60
		time_components = [hours, minutes, seconds]
		time_displays = []
		time_components.each do |component|
			time_displays.push(padded(component))
		end
		time_displays.join(":")
	end

	def padded(number)
		if number < 10
			return "0#{number}"
		else
			return "#{number}"
		end
	end
end
