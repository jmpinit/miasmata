# Player class.
require '.\Entity'
require '.\Animation'

class Human < Entity
	attr_reader :direction, :velocity
	
	def initialize(window, x, y)
		super(window, x, y, 4, 8)
		
		# Load all animation frames
		frames = Image.load_tiles(window, "res/player.png", 4, 8, false);
		@animations = {	"walk_r"	=>Animation.new(frames, 0, 4, 10),
						"walk_l"	=>Animation.new(frames, 4, 4, 10),
						"run_r"		=>Animation.new(frames, 8, 4, 10),
						"run_l"		=>Animation.new(frames, 12, 4, 10),
						"climb_r"	=>Animation.new(frames, 16, 2, 10),
						"climb_l"	=>Animation.new(frames, 18, 2, 10),
						"idle_r"	=>Animation.new(frames, 20, 1, 10),
						"idle_l"	=>Animation.new(frames, 21, 1, 10) }
		
		@anim = @animations["idle_r"]
		
		@dir = :right
		
		@brightness = 0
	end
	
	def update
		apply_gravity
		apply_limits
		move
		@normal = collide_map
		
		if(@vx.abs<0.1)
			if(@dir==:right)
				@anim = @animations["idle_r"]
			else
				@anim = @animations["idle_l"]
			end
		end
	end
	
	def try_to_jump
		if(@normal)
			if(@normal==$DIR_UP)
				@vy = -3
			end
		end
	end
	
	def try_to_move(dir)
		if(@normal)
			@dir = dir
			
			if(dir==:right)
				@vx += 0.15
				@anim = @animations["walk_r"]
			else
				@vx -= 0.15
				@anim = @animations["walk_l"]
			end
		end
	end
	
	def draw(cam_x, cam_y)
		@anim.next.draw(@x-cam_x, @y-cam_y, 0, 1.0, 1.0, light_lookup(@brightness))
	end
end