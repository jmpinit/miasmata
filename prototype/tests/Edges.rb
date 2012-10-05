require 'rubygems'
require 'gosu'
include Gosu

$white = Color.new(255, 255, 255)
$red = Color.new(255, 0, 0)
$green = Color.new(0, 255, 0)
$blue = Color.new(0, 0, 255)
$gray = Color.new(128, 128, 128)

class Edges < Window
	attr_reader :map
	
	SIZE = 128

	def initialize
		super(640, 480, false)
		
		self.caption = "Vector Math"
		
		@object = Box.new(self, $gray, 0, 0, 32, 32)
		@tile = Box.new(self, $white, 0, 0, SIZE/2, SIZE/2)
		@normal = 3*Math::PI/2
	end
  
	def update
		@object.x = mouse_x - width/2
		@object.y = mouse_y - height/2
		
		
		dir = (3*Math::PI/2-Math.atan2(@tile.midx-@object.midx, @tile.midy-@object.midy))+Math::PI/4
		quantized = (dir/(Math::PI/2)).floor*(Math::PI/2)
		
		@normal = quantized
	end
  
	def draw
		translate(width/2, height/2) do
			@object.draw
			@tile.draw
			draw_line(0, 0, $blue, 50*Math.cos(@normal), 50*Math.sin(@normal), $blue)
		end
	end
  
	def button_down(id)
		if id == KbEscape then close end
	end
end

class Box
	attr_reader :width, :height
	attr_accessor :x, :y
	
	def initialize(window, color, x, y, width, height)
		@window = window
		@color = color
		
		@x = x
		@y = y
		
		@width = width
		@height = height
	end
	
	def midx
		x+width/2
	end
	
	def midy
		y+height/2
	end
	
	def draw
		@window.draw_quad(@x-width/2, @y-height/2, @color, @x+width/2, @y-height/2, @color, @x+width/2, @y+height/2, @color, @x-width/2, @y+height/2, @color)
	end
end

Edges.new.show