class Animation
	attr_accessor	:speed
	
	def initialize(source, start, length, speed)
		@frames = Array.new(length)
		
		#add frames from main pool to private
		for i in 0...length
			@frames[i] = source[i+start]
		end
		
		@pos = 0
		@delay = 0
		@speed = speed
	end
	
	def reset
		pos = 0
	end
	
	def frame(newPos)
		@pos = newPos if newPos<@frames.length
	end
	
	def next
		if(@delay>=@speed)
			@pos += 1
			@pos = 0 if @pos>=@frames.length
			
			@delay = 0
		else
			@delay += 1
		end
		
		return @frames[@pos]
	end
end