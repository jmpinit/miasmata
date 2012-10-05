class Ball < Entity
	attr_reader :direction, :velocity

	def initialize(window, x, y)
		super(window, x, y, 4, 4)
		
		# Load all animation frames
		frames = Image.load_tiles(window, "res/ball.png", 4, 4, false);
		@animations = {	"static"	=>Animation.new(frames, 0, 1, 10)}
		
		@anim = @animations["static"]
		
		@brightness = 1
	end
	
	def update
		# gravity
		@vy += 0.1 if @vy<Entity::MAX_SPEED
		
		# limits
		if(@vy>Entity::MAX_SPEED)
			@vy = Entity::MAX_SPEED
		end
		if(@vy<-Entity::MAX_SPEED)
			@vy = -Entity::MAX_SPEED
		end
		
		if(@vx>Entity::MAX_SPEED)
			@vx = Entity::MAX_SPEED
		end
		if(@vx<-Entity::MAX_SPEED)
			@vx = -Entity::MAX_SPEED
		end
	
		# movement
		@direction = Math.atan2(@vx, @vy)
		@velocity = Math.sqrt(@vx**2+@vy**2)
		@x += @vx
		@y += @vy
		
		# collision detection
		adjacent = [@map.tile(@x, @y), @map.tile(@x+@width, @y), @map.tile(@x, @y+@height), @map.tile(@x+@width, @y+@height)]
		adjacent.each do |tile|
			tile.collide(self) if tile
		end
	end
	
	def draw(cam_x, cam_y)
		@anim.next.draw(@x-cam_x, @y-cam_y, 0, 1.0, 1.0, light_lookup(@brightness))
	end
end