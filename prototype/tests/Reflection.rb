require 'rubygems'
require 'gosu'
include Gosu

class Reflection < Window
	attr_reader :map

	def initialize
		super(640, 480, false)
		
		# make things retro
		begin; Gosu::enable_undocumented_retrofication; rescue; end
		self.caption = "Reflection Math"
		
		@white = Color.new(255, 255, 255)
		@red = Color.new(255, 0, 0)
		@green = Color.new(0, 255, 0)
		@blue = Color.new(0, 0, 255)
		@gray = Color.new(128, 128, 128)
		
		@in_trajectory = 0
		@normal = 3*Math::PI/2
		
		@out_trajectory = reflect(@normal, @in_trajectory)
	end
  
	def update
		#@normal = mouse_y/(16*Math::PI)
		@in_trajectory += 0.01
		@normal += 0.001
		
		# calculate out trajectory
		@out_trajectory = reflect(@normal, @in_trajectory)
		
		#puts (@in_trajectory/Math::PI).to_s+" vs "+(@out_trajectory/Math::PI).to_s
	end
	
	def reflect(n, t)
		n+(n-t)+Math::PI
	end
  
	def draw
		translate(width/2, height/2) do
			self.scale(2,2) do
				# draw surface
				draw_line(-50*Math.cos(@normal-Math::PI/2), -50*Math.sin(@normal-Math::PI/2), @white, 50*Math.cos(@normal-Math::PI/2), 50*Math.sin(@normal-Math::PI/2), @white)
				
				# draw normal
				draw_line(0, 0, @blue, 50*Math.cos(@normal), 50*Math.sin(@normal), @blue)
				
				# draw in trajectory
				draw_line(-50*Math.cos(@in_trajectory), -50*Math.sin(@in_trajectory), @red, 0, 0, @red)
				
				# draw out trajectory
				draw_line(0, 0, @green, 50*Math.cos(@out_trajectory), 50*Math.sin(@out_trajectory), @green)
			end
		end
	end
  
	def button_down(id)
		if id == KbEscape then close end
	end
end

Reflection.new.show