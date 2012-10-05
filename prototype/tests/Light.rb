require 'rubygems'
require 'gosu'
include Gosu

$black = Color.new(0, 0, 0)
$white = Color.new(255, 255, 255)
$red = Color.new(255, 0, 0)
$green = Color.new(0, 255, 0)
$blue = Color.new(0, 0, 255)
$gray = Color.new(128, 128, 128)

class Light_Viewer < Window
	attr_reader :map
	
	SIZE = 8
	WIDTH = 32
	HEIGHT = 32
	
	def initialize
		super(640, 480, false)
		
		self.caption = "THERE WILL BE LIGHT"
		
		@object = Box.new(self, $blue, 0, 0, 32, 32)
		@source = Light.new(self, WIDTH/2, HEIGHT/2)
		
		# light array
		@light_map = Hash.new(0)
		# for y in 0..32
			# for x in 0..32
				# @light_map[[x, y]]= 255
			# end
		# end
	end
	
	def calc_light
		for y in 0..HEIGHT
			for x in 0..WIDTH
				visible = ray(x, y, @source.x, @source.y)
				
				if(visible)
					@light_map[[x, y]] = 255
				else
					@light_map[[x, y]] = 0
				end
			end
		end
	end
	
	def ray(x0, y0, x1, y1)
		dx = (x1-x0).abs
		dy = (y1-y0).abs
		
		if(x0<x1)
			sx = 1
		else
			sx = -1
		end
		
		if(y0<y1)
			sy= 1
		else
			sy = -1
		end
		
		err = dx-dy
		
		while true
			return false if(@object.within?(x0*SIZE, y0*SIZE))
			
			break if(x0==x1 and y0==y1)
			
			e2 = 2*err
			if(e2>-dy)
				err -= dy
				x0 += sx
			end
			
			if(e2<dx)
				err += dx
				y0 += sy
			end
		end
		
		return true
	end
  
	def update
		@object.x = mouse_x
		@object.y = mouse_y
		
		calc_light
	end
  
	def draw
		for y in 0..HEIGHT
			for x in 0..WIDTH
				lum = @light_map[[x, y]]
				if lum>128
					draw_light(x*SIZE, y*SIZE, $white)
				else
					draw_light(x*SIZE, y*SIZE, $black)
				end
			end
		end
		
		@object.draw
		@source.draw
	end
	
	def draw_light(x, y, luminance)
		draw_quad(x, y, luminance, x+SIZE, y, luminance, x+SIZE, y+SIZE, luminance, x, y+SIZE, luminance)
	end
  
	def button_down(id)
		if id == KbEscape then close end
	end
end

class Light
	attr_accessor :x, :y
	
	def initialize(window, x, y)
		@window = window
		@x, @y = x, y
	end
	
	def draw
		size = Light_Viewer::SIZE
		@window.draw_quad(@x*size-2, @y*size-2, $green, @x*size+2, @y*size-2, $green, @x*size+2, @y*size+2, $green, @x*size-2, @y*size+2, $green)
	end
end

class Box
	attr_reader :width, :height
	attr_accessor :x, :y
	
	def initialize(window, color, x, y, width, height)
		@window = window
		@color = color
		
		@x, @y = x, y
		
		@width = width
		@height = height
	end
	
	def within?(x, y)
		return true if(x>(@x-width/2) and x<(@x+width/2) and y>(@y-width/2) and y<(@y+height/2))
		false
	end
	
	def draw
		@window.draw_quad(@x-width/2, @y-height/2, @color, @x+width/2, @y-height/2, @color, @x+width/2, @y+height/2, @color, @x-width/2, @y+height/2, @color)
	end
end

Light_Viewer.new.show