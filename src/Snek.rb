require "ruby2d"

class Snek

	def initialize board_start_x, board_start_y, board_width, board_height, grid_size
		@body = [[0,0],[1,0],[2,0]].reverse
		@head = @body.first
		@vel = [0,1]
		@grid_size = grid_size
		@board_start = [board_start_x, board_start_y]
		@board_dimensions = [board_width, board_height]
		@grown = false
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
			raise "out Of bounds"
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
				pos = [@head[0],@head[1]-1]
			when "a" then
				pos = [@head[0]-1,@head[1]]
			when "s" then
				pos = [@head[0],@head[1]+1]
			when "d" then
				pos = [@head[0]+1,@head[1]]
		end
		
		if @body.include? pos then
			puts "dead"
			raise "dead"
			return false
		else
			return true
		end

	end
	
	def grown?
		@grown
	end
end
