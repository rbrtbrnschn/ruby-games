require "ruby2d"

class Game
	
	def draw start_x,start_y,width,height
		# Board
		Quad.new(
			x1: start_x, y1: start_y, 
			x2: width+start_x, y2: start_y, 
			x3: width+start_x, y3: start_y+height, 
			x4: start_x, y4: start_y+height, 
			color: "white"
		)

	end
	
	def finished?
		@finished
	end

end
