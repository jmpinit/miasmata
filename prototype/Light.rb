class Light
	attr_reader :x, :y

	def initialize(window, x, y)
		@window = window
		@x = x
		@y = y
	end
	
	def light_map1
		for rel_y in -32..32
			for rel_x in -32..32
				tile = @window.map.solid?(@x+rel_x*Tile::SIZE, @y+rel_y*Tile::SIZE)
				
				if(tile)
					dist = Math.sqrt(rel_x**2+rel_y**2)
					level = 255-dist*32
					level = 0 if level<0
					tile.brightness += level
				end
			end
		end
	end
	
	def light_map2
		for rel_y in -32..32
			for rel_x in -32..32
				# dist = Math.sqrt(y**2+x**2)
				tile = @window.map.solid?(@x+rel_x*Tile::SIZE, @y+rel_y*Tile::SIZE)
				
				if(tile)
					index_x = (@x/Tile::SIZE).floor
					index_y = (@y/Tile::SIZE).floor
					
					dist = ray(index_x+rel_x, index_y+rel_y, index_x, index_y)
					if(dist>0)
						tile.brightness += 255-dist*16
					end
				end
			end
		end
	end
	
	def light_objects
		$objects.each do |o|
			if(Math.sqrt((o.x-@x)**2+(o.y-@y)**2)<512)
				level = 255-Math.sqrt((o.x-@x)**2+(o.y-@y)**2)*4
				level = 0 if level<0
				o.brightness += level
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
		
		count = 0
		while true
			#puts "("+x0.to_s+", "+y0.to_s+") = "+@window.map.solid?(x0*Tile::SIZE, y0*Tile::SIZE).class.to_s
			
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
			
			if(@window.map.solid?(x0*Tile::SIZE, y0*Tile::SIZE))
				return -1
			end
			
			count += 1
		end
		
		return count
	end
end