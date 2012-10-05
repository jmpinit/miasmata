class Tile
	attr_reader :image, :size, :x, :y, :last_norm, :friction, :bounce
	attr_accessor :brightness
	
	SIZE = 8
	
	def initialize(type, image, x, y, friction, bounce, passable = false)
		@type = type
		@image = image
		@x, @y = x, y
		@passable = passable
		@friction = friction
		@bounce = bounce
		@brightness = 0
	end
	
	# assumes it is solid
	def collide(object)
		# reverse direction of velocity
		direction = (object.direction+Math::PI)%(2*Math::PI)
		
		# length of projection
		x_overlap = min(@x+SIZE, object.x+object.width)-max(@x, object.x);
		y_overlap = min(@y+SIZE, object.y+object.height)-max(@y, object.y);
		
		w = x_overlap.abs
		h = y_overlap.abs
		
		if(direction>$DIR_RIGHT and direction<$DIR_DOWN)
			#first quadrant
			div = Math.atan2(h, w)
			
			if(direction>div)
				length = (h/2)/Math.sin(direction)
			else
				length = (w/2)/Math.cos(direction)
			end
			
			length *= 2
		elsif(direction>$DIR_DOWN and direction<$DIR_LEFT)
			#second quadrant
			div = Math.atan2(w, h)
			adj_angle = direction-Math::PI/2
			
			if(adj_angle>div)
				length = (w/2)/Math.sin(adj_angle)
			else
				length = (h/2)/Math.cos(adj_angle)
			end
			
			length *= 2
		elsif(direction>$DIR_LEFT and direction<$DIR_UP)
			#third quadrant
			div = Math.atan2(h, w)
			adj_angle = direction-Math::PI
			
			if(adj_angle>div)
				length = (h/2)/Math.sin(adj_angle)
			else
				length = (w/2)/Math.cos(adj_angle)
			end
			
			length *= 2
		elsif(direction>$DIR_UP and direction<2*Math::PI)
			#fourth quadrant
			div = Math.atan2(w, h)
			adj_angle = direction-3*Math::PI/2
			
			if(adj_angle>div)
				length = (w/2)/Math.sin(adj_angle)
			else
				length = (h/2)/Math.cos(adj_angle)
			end
			
			length *= 2
		elsif(direction==$DIR_RIGHT or direction==$DIR_LEFT)
			length = w
		elsif(direction==$DIR_DOWN or direction==$DIR_UP)
			length = h
		end
		
		# correct position
		object.x += length*Math.cos(direction)
		object.y += length*Math.sin(direction)
		
		# calculate surface normal
		dir = ($DIR_UP-Math.atan2(midx-object.midx, midy-object.midy))+Math::PI/4
		normal = (dir/(Math::PI/2)).floor*(Math::PI/2)
		@last_norm = normal
		return normal
	end
	
	def midx
		x+SIZE/2
	end
	
	def midy
		y+SIZE/2
	end
	
	def min(p1, p2)
		if(p1<p2)
			return p1
		else
			return p2
		end
	end
	
	def max(p1, p2)
		if(p1>p2)
			return p1
		else
			return p2
		end
	end
end

# Map class holds and draws tiles and gems.
class Map
	attr_reader :width, :height
  
	def initialize(window, filename)
		@window = window
	
		img_rock, img_dirt = *Image.load_tiles(window, "res/tiles/tileset.png", 8, 8, true)
		
		@height = 256
		@width = 256
		
		@draw_width = @window.width/Tile::SIZE
		@draw_height = @window.height/Tile::SIZE
		
		map_src = Image.new(@window, "res/map.png")
		@tiles = Array.new(@width)
		
		@light_levels = Array.new(256)
		inc = 256/@light_levels.length
		for i in 0...@light_levels.length
			level = i*inc
			@light_levels[i] = Color.new(level, level, level)
		end
		
		c_rock = [0, 0, 0, 256]
		c_dirt = [256, 0, 0, 256]
		c_light = [0, 256, 0, 256]
		
		puts "loading map"
		
		for x in 0...width
			@tiles[x] = Array.new(@height)
			
			for y in 0...height
				colors = map_src.get_pixel(x, y)
				for i in 0...colors.length
					colors[i] = (colors[i]*256).floor
				end
				
				case colors
					when c_rock
						@tiles[x][y] = Tile.new(:rock, img_rock, x*Tile::SIZE, y*Tile::SIZE, 0.8, 0.2)
					when c_dirt
						@tiles[x][y] = Tile.new(:dirt, img_dirt, x*Tile::SIZE, y*Tile::SIZE, 0.8, 0.2)
					when c_light
						$lights<<Light.new(@window, x*Tile::SIZE, y*Tile::SIZE)
					else
						nil
				end
			end
		end
	end
  
	def draw(cam_x, cam_y)
		# draw tiles
		for y in 0...@draw_height
			for x in 0...@draw_width
				tile = tile(cam_x+x*Tile::SIZE, cam_y+y*Tile::SIZE)
				if tile
					tile.image.draw(x*Tile::SIZE-cam_x%Tile::SIZE, y*Tile::SIZE-cam_y%Tile::SIZE, 0, 1.0, 1.0, light_lookup(tile.brightness))
				end
			end
		end
	end
	
	def reset_lighting
		for y in 0...@height
			for x in 0...@width
				tile = @tiles[x][y]
				if tile
					tile.brightness = 32
				end
			end
		end
	end
	
	def light_lookup(val)
		index = val-val%(256/@light_levels.length)
		index = 0 if index<0
		index = @light_levels.length-1 if index>=@light_levels.length
		return @light_levels[index]
	end
	
	# Solid at a given pixel position?
	def solid?(x, y)
		if(x>=0 and y>=0 and x<@width*Tile::SIZE and y<@height*Tile::SIZE)
			return @tiles[x/Tile::SIZE][y/Tile::SIZE]
		else
			return nil
		end
	end
	
	def tile(x, y)
		index_x = x/Tile::SIZE
		index_y = y/Tile::SIZE
		
		if(index_x>=0 and index_x<@tiles.length and index_y>=0 and index_y<@tiles.length)
			return @tiles[index_x][index_y]
		else
			return nil
		end
	end
end