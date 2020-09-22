require "ruby2d"

class Game
	attr_accessor :food	
	def initialize start_x,start_y,width,height,grid_size
		@board_start = [start_x,start_y]
		@board_dimensions = [width,height]
		@grid_size = grid_size
		@food = [[5,10]]
		@finished = false
		@score = 1
	end

	def draw
		# Board
		s = @board_start
		dim = @board_dimensions
		if self.finished? then
			return
		end
		Quad.new(
			x1: s[0], y1: s[1], 
			x2: s[0] + dim[0], y2: s[1], 
			x3: s[0] + dim[0], y3: s[1] + dim[1], 
			x4: s[0], y4: s[1] + dim[1], 
			color: "white"
		)
		@food.each do |foo|
			x,y = self.get_coordinates foo
			Square.new(x: x, y: y, color: "yellow", z:1, size: @grid_size)
		end
	end
	
	def finished?
		@finished
	end

	def finish
		@finished = true
	end

	def clean
		@food = []

	end
	

	def get_coordinates food
		return food[0]*@grid_size + @board_start[0], food[1]*@grid_size + @board_start[1]
	end
	
	def spawn_food
		max_x = @board_dimensions[0] / @grid_size
		max_y = @board_dimensions[1] / @grid_size
		x = rand(max_x)
		y = rand(max_y)
		@food.push([x,y])
	end

	def snek_food_collision snek
		@food.each do |foo|
			if snek.head == foo then
				@food.delete foo
				snek.grow
				@score += 1
			end

		end
	end

	def gameover_screen
		start = @board_start
		dim = @board_dimensions
		size = 35
		Text.new("Game over, to restart hit 'r'", color:"red", x:(start[0]+dim[0])/2-size*6, y: (start[1]+dim[1])/2-size, size:size)
		Text.new("Your Score: #{@score}", color:"red", x:(start[0]+dim[0])/2-size*6, y: (start[1]+dim[1])/2-size*3, size:size)
		
	end
end
