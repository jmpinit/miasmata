require 'rubygems'
require 'gosu'
require 'texplay'
include Gosu

require '.\Map'
require '.\Entity'
require '.\Animation'

require '.\Human'
require '.\Ball'
require '.\Light'

$c_blue = Color.new(0, 0, 255)
$c_green = Color.new(0, 255, 0)

$gravity = 0.1

$DIR_UP		= 3*Math::PI/2
$DIR_DOWN	= Math::PI/2
$DIR_LEFT	= Math::PI
$DIR_RIGHT	= 0

$objects = Array.new
$lights = Array.new

class Game < Window
	attr_reader :map, :camera_x, :camera_y

	def initialize
		super(640, 480, false)
		
		# make things retro
		begin; Gosu::enable_undocumented_retrofication; rescue; end
		self.caption = "Miasmata"
		@camera_x = @camera_y = 0
		
		# set up game
		@map = Map.new(self, "res/map.txt")
		@ply = Human.new(self, 32, 16)
		$objects<<@ply
		
		@map.reset_lighting
		$lights.each { |light| light.light_map1 }
	end
  
	def update
		@ply.try_to_move(:left) if button_down? KbLeft
		@ply.try_to_move(:right) if button_down? KbRight
		@ply.try_to_jump if button_down? KbSpace
		
		$objects.each { |o| o.update }
		
		@camera_x = @ply.x-100
		@camera_y = @ply.y-100
		
		@ply.brightness = 0
		$lights.each { |light| light.light_objects }
	end
  
	def draw
		self.scale(2,2) do
			@map.draw(@camera_x, @camera_y)
			
			$objects.each { |o| o.draw(@camera_x, @camera_y) }
			
			$lights.each { |l| draw_quad(l.x-@camera_x, l.y-@camera_y, $c_blue, l.x+4-@camera_x, l.y-@camera_y, $c_blue, l.x+4-@camera_x, l.y+4-@camera_y, $c_blue, l.x-@camera_x, l.y+4-@camera_y, $c_blue) }
		end
	end
  
	def button_down(id)
		if id == KbEscape then close end
	end
end

Game.new.show
