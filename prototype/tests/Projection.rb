require 'rubygems'
require 'gosu'
include Gosu

class Projection < Window
	attr_reader :map

	def initialize
		super(640, 480, false)
		
		# make things retro
		begin; Gosu::enable_undocumented_retrofication; rescue; end
		self.caption = "Project out of a rect"
		
		@white = Color.new(255, 255, 255)
		@red = Color.new(255, 0, 0)
		@green = Color.new(0, 255, 0)
		@blue = Color.new(0, 0, 255)
		@gray = Color.new(128, 128, 128)
		
		@direction = 0
		@width = 100
		@height = 30
		@magnitude = 0
	end
  
	def update
		w = @width
		h = @height
		direction = @direction%(2*Math::PI)
		
		if(direction>0 and direction<Math::PI/2)
			#first quadrant
			div = Math.atan2(h, w)
			
			if(direction>div)
				length = (h/2)/Math.sin(direction)
			else
				length = (w/2)/Math.cos(direction)
			end
		elsif(direction>Math::PI/2 and direction<Math::PI)
			#second quadrant
			div = Math.atan2(w, h)
			adj_angle = direction-Math::PI/2
			
			if(adj_angle>div)
				length = (w/2)/Math.sin(adj_angle)
			else
				length = (h/2)/Math.cos(adj_angle)
			end
		elsif(direction>Math::PI and direction<3*Math::PI/2)
			#third quadrant
			div = Math.atan2(h, w)
			adj_angle = direction-Math::PI
			
			if(adj_angle>div)
				length = (h/2)/Math.sin(adj_angle)
			else
				length = (w/2)/Math.cos(adj_angle)
			end
		elsif(direction>3*Math::PI/2 and direction<2*Math::PI)
			#fourth quadrant
			div = Math.atan2(w, h)
			adj_angle = direction-3*Math::PI/2
			
			if(adj_angle>div)
				length = (w/2)/Math.sin(adj_angle)
			else
				length = (h/2)/Math.cos(adj_angle)
			end
		elsif(direction==0 or direction==Math::PI)
			length = w/2
		elsif(direction==Math::PI/2 or direction==3*Math::PI/2)
			length = h/2
		end
		
		@magnitude = length
		
		@direction += 0.01
	end
  
	def draw
		translate(width/2, height/2) do
			self.scale(2,2) do
				# draw rect
				draw_quad(-@width/2, -@height/2, @white, @width/2, -@height/2, @white, @width/2, @height/2, @white, -@width/2, @height/2, @white)
				
				# draw in trajectory
				draw_line(-500*Math.cos(@direction), -500*Math.sin(@direction), @red, 500*Math.cos(@direction), 500*Math.sin(@direction), @red)
				
				# draw projection
				draw_line(0, 0, @green, @magnitude*Math.cos(@direction), @magnitude*Math.sin(@direction), @green)
			end
		end
	end
  
	def button_down(id)
		if id == KbEscape then close end
	end
end

Projection.new.show