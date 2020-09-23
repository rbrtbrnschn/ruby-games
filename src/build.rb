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
		line_width = 10
		x1 = s[0] 
		y1= s[1]
		x2 = s[0] + dim[0]
		y2 = s[1]
		x3 = s[0] + dim[0] 
		y3 = s[1] + dim[1]
		x4 = s[0]
		y4= s[1] + dim[1]

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
		Line.new(x1: x1 - @grid_size - (line_width/2), y1: y1 - @grid_size, x2: x2 + @grid_size + line_width/2, y2: y2 - @grid_size, width: 10, z: 1)
		Line.new(x1: x2 + @grid_size, y1: y2 - @grid_size, x2: x3 + @grid_size, y2: y3 + @grid_size, width: 10, z: 1)
		Line.new(x1: x3 + @grid_size + (line_width/2), y1: y3 + @grid_size, x2: x4 - @grid_size - line_width/2, y2: y4 + @grid_size, width: 10, z: 1)
		Line.new(x1: x4 - @grid_size, y1: y4 + @grid_size, x2: x1 - @grid_size, y2: y1 - @grid_size, width: line_width, z: 1)

		Text.new("Score: #{@score}", font: "/usr/share/fonts/truetype/Gargi/Gargi.ttf")

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

class Snek
	attr_accessor :head
	def initialize board_start_x, board_start_y, board_width, board_height, grid_size, game
		@body = [[0,0],[1,0],[2,0]].reverse
		@head = @body.first
		@vel = [0,1]
		@grid_size = grid_size
		@board_start = [board_start_x, board_start_y]
		@board_dimensions = [board_width, board_height]
		@grown = false
		@food = game.food
		@game = game
	end
	
	def get_coordinates body_piece
		return body_piece[0]*@grid_size + @board_start[0], body_piece[1]*@grid_size + @board_start[1]
	end

	def draw
		@body.each do |piece|
			x, y = self.get_coordinates piece
			Square.new(x: x, y: y, size: @grid_size, color: "green")
		end
	end
	
	# Move A Space
	def thrust
		@head[0] += @vel[0]
		@head[1] += @vel[1]
	end

	def move
		if @grown then
			raise "didnt implement self.grown?()"
		end
		self.in_bounds?
		last = @head.dup
		self.thrust
		@body.push(last)
		@body.shift

	end

	def in_bounds?
		if @head[0] >= 0 && @head[1] >= 0 and @head[0] < @board_dimensions[0]/@grid_size and @head[1] < @board_dimensions[1]/@grid_size then
			return true 
		else
			@game.finish
			return false
		end
	end
	
	def change_dir dir
		case dir
			when "w" then
				@vel = [0,-1]
			when "a" then
				@vel = [-1,0]
			when "s" then
				@vel = [0,1]
			when "d" then
				@vel = [1,0]
		end
	end

	def change_dir_possible? dir
		case dir
			when "w" then
				if @vel == [0,1] then
					return false
				end
				pos = [@head[0],@head[1]-1]
			when "a" then
				if @vel == [1,0] then
					return false
				end
				pos = [@head[0]-1,@head[1]]
			when "s" then
				if @vel == [0,-1] then
					return false
				end
				pos = [@head[0],@head[1]+1]
			when "d" then
				if @vel == [-1,0] then
					return false
				end
				pos = [@head[0]+1,@head[1]]
		end
		
		if @body.include? pos then
			@game.finish
			return false
		else
			return true
		end

	end
	
	def grow
		@body.push(@body.last)
	end
	
	def grown?
		@grown
	end

	def clean
		@body = []
	end


end

# Window
window_width = 800
window_height = 800
set ({ width: window_width, height: window_height, background: "navy", resizable: true, fps_cap:20})

# Board
board_width = 700
board_height = 450
board_margin_top = 300
board_margin_sides = 50
grid_size = 25
# Setup
game = Game.new board_margin_sides, board_margin_top, board_width, board_height, grid_size
snek = Snek.new board_margin_sides, board_margin_top, board_width, board_height, grid_size, game
time = Time.now.to_i

update do
	clear
	if !game.finished?
		snek.move
	else
		game.clean
		snek.clean
		game.gameover_screen
	end

	game.snek_food_collision snek
	game.draw 
	snek.draw
	
	on :key_down do |event|
		if ["w","a","s","d","r"].include? event.key then
			if ["r"].include? event.key then
				game = Game.new board_margin_sides, board_margin_top, board_width, board_height, grid_size
				snek = Snek.new board_margin_sides, board_margin_top, board_width, board_height, grid_size, game

			end
			if snek.change_dir_possible? event.key then
				snek.change_dir event.key
			end
		end
	end
	
	if Time.now.to_i - time >= 1 then
		time = Time.now.to_i
		game.spawn_food
	end
end


show
