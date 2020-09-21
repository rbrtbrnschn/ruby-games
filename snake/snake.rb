#!/usr/bin/env ruby
require "ruby2d"

# Settings
set ( {width: 800, height: 800, background: "white", title: "Snake"} )
@block_size = 50
tick = 0
test = 0
@x = 3*@block_size
@y = 0 
@dir = 1

# Snake
@snake = [Square.new(x:3*@block_size,y:0,z:1,size:@block_size, color:"red")]
@last = @snake.last

# Food
@food = []
@food_coords = []

# Helpers
def in_bounds?(x,y)
	if x < Window.width and x >= 0 and y < Window.height and y >= 0
	then return true
	else return false end
end

def change_dir()
		on :key_down do |event|
			key = event.key
			case key
				when "w"
					@dir = 0
				when "a"
					@dir = 3
				when "s"
					@dir = 2
				when "d"
					@dir = 1
			end
		end
end

def calculate_new_dir()
	y = @y
	x = @x
	case @dir
		when 0
			y -=	@block_size
		when 1
			x +=	@block_size
		when 2
			y += @block_size
		when 3
			x -= @block_size
	end

	if in_bounds?(x,y)
	then
		return x, y
	else
		return @x,@y
	end
	
end

def grow()
	x = @last.x
	y = @last.y
	@snake.push(
	Square.new(
		x: x, 
		y: y,
		z: 1,
		color: "black",
		size: @block_size
	))

end

def spawn_food()
	x = rand((Window.width/@block_size).to_i)*@block_size
	y = rand((Window.height/@block_size).to_i)*@block_size
	@food.push(Square.new(
		x: x,
		y: y,
		z: 0,
		size: @block_size,
		color: "yellow"
	))
	@food_coords.push([x,y])
end

def eat()
	if @food_coords.include?([@x,@y]) then
		@food_coords.delete([@x,@y])
		food = @food.detect {|f| f.x == @x and f.y == @y}
		@food.delete(food)
		food.remove()
		grow()
	end
	return
end

def crash()
	x, y = calculate_new_dir()
	if [x,y] == [@x,@y] then
		clear
		raise "Game Over"
		return
	end
	if (@snake.select {|s| s.x == @x and s.y == @y}).length > 1 then
		clear
		raise "Game Over"
		return
	end
end

def move()
	length = @snake.length
	last = @snake[length - 1]
	new_x, new_y = calculate_new_dir()
	if [new_x,new_y] == [@x,@y] then Text.new("rip",color: "green", z: 2); return end
	last.x = new_x
	last.y = new_y
	@x = last.x
	@y = last.y
	
	@snake.pop()
	@snake.insert(0,last)

	# Make snek great again
	@snake[0].color = "red"
	if @snake.length >= 2 then @snake[1].color = "black" end

end


# Update Loop
update do
change_dir()
if tick % 20 == 0
	then
		move()
		crash()
		eat()
		tick = 0
		test += 1
	end
	tick += 1
	if test == 5 then
		spawn_food()
		test = 0
	end

end



show

