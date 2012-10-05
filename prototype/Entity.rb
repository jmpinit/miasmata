class Entity
	attr_accessor :x, :y, :vx, :vy
	attr_reader :width, :height
	attr_accessor :brightness
	
	MAX_SPEED = 8
	
	LIGHT_LEVELS = Array.new(256)
	inc = 256/LIGHT_LEVELS.length
	for i in 0...LIGHT_LEVELS.length
		level = i*inc
		LIGHT_LEVELS[i] = Color.new(level, level, level)
	end
	
	def initialize(window, x, y, w, h)
		@window = window
		
		@width, @height = w, h
		@x, @y = x, y
		@vx = @vy = 0
		@direction = 0
		
		@map = window.map
		
		@normal = $DIR_UP
	end
	
	def light_lookup(val)
		index = val-val%(256/LIGHT_LEVELS.length)
		index = 0 if index<0
		index = LIGHT_LEVELS.length-1 if index>=LIGHT_LEVELS.length
		return LIGHT_LEVELS[index]
	end
	
	def apply_gravity
		# gravity
		@vy += $gravity
	end
	
	def apply_limits
		# gravity
		@vy += $gravity if @vy<Entity::MAX_SPEED
		
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
	end
	
	def move
		@direction = Math.atan2(@vy, @vx)
		@velocity = Math.sqrt(@vx**2+@vy**2)
		@x += @vx
		@y += @vy
	end
	
	def collide_map
		adjacent = [@map.tile(@x, @y), @map.tile(@x+@width, @y), @map.tile(@x, @y+@height), @map.tile(@x+@width, @y+@height)]
		
		shortest_dist = Entity::MAX_SPEED*2
		correct_norm = nil
		collide_tile = 0
		count = 0
		adjacent.each do |tile|
			if(tile)
				curr_dist = Math.sqrt((midx-tile.midx)**2+(midy-tile.midy)**2)
				curr_norm = tile.collide(self)
				
				if(curr_dist<shortest_dist)
					shortest_dist = curr_dist
					correct_norm = curr_norm
					collide_tile = tile
				end
				
				count += 1
			end
		end
		
		if(count>0)
			reflected = correct_norm+(correct_norm-@direction)+Math::PI
			oriented = reflected - (correct_norm-Math::PI/2)
			x_component = @velocity*Math.cos(oriented)
			y_component = @velocity*Math.sin(oriented)
			
			x_component *= collide_tile.friction
			y_component *= collide_tile.bounce
			
			trajectory = Math.atan2(y_component, x_component) + (correct_norm-Math::PI/2)
			new_velocity = Math.sqrt(x_component**2+y_component**2)
			
			# apply physics
			@vx = new_velocity*Math.cos(trajectory)
			@vy = new_velocity*Math.sin(trajectory)
			
			# go where we should have gone in the first place
			@x += @vx
			@y += @vy
		end
		
		return correct_norm
	end
	
	def midx
		@x+@width/2
	end
	
	def midy
		@y+@height/2
	end
end