#!/usr/bin/env ruby
require "ruby2d"

# Setting
set ( {width: 800, height: 800,viewport_width: 800, viewport_height: 800, background: "black", title: "Snake", fullscreen: true} )
@block_size = 50
tick = 0
spawn_food_tick = 0
@has_eaten = false
@move_time = 20  # 20 is default
@food_spawn_time = 3  # 5 is default
@x = 3*@block_size
@y = 0 
@dir = 1

# Snake
@snake = [Square.new(x:3*@block_size,y:0,z:1,size:@block_size, color:"green")]
@last = @snake.last
@length = @snake.length

# Food
@food = []
@food_coords = []

# Helpers

def scoreboard()
	scoreboard_text = Text.new("Length: #{@snake.length}",x: 0,y: 0, size: 50, z:100)
	scoreboard_bg = Square.new(x:0,y:0,size:50,z:10)
end

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
		color: "white",
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
		@has_eaten = true
		@food_coords.delete([@x,@y])
		food = @food.detect {|f| f.x == @x and f.y == @y}
		@food.delete(food)
		food.remove()
		grow()
	else
		@has_eaten = false
	end
	return
end

def crash()
	x, y = calculate_new_dir()

	if [x,y] == [@x,@y] then
		end_game "out of bounds"
		return
	end
	if (@snake.select {|s| s.x == @x and s.y == @y}).length > 1 and !@has_eaten then
		end_game("Hit Snek")
		return
	end
end

def end_game(reason)
	clear
	Text.new(
  "Game Over!",
  x: Window.width/2-100*3, y: Window.height/2-100,
  size: 100,
  color: 'red',
  rotate: 360,
  z: 10
)
	on :key_down do |key|
		win = get :window
		puts "window: #{win}"
		value = `ruby snake.rb`
		value = `#{value}`
	end
end

def move()
	length = @snake.length
	last = @snake[length - 1]
	new_x, new_y = calculate_new_dir()
	last.x = new_x
	last.y = new_y
	@x = last.x
	@y = last.y
	
	@snake.pop()
	@snake.insert(0,last)

	# Make snek great again
	@snake[0].color = "green"
	if @snake.length >= 2 then @snake[1].color = "white" end

end
# Setup
scoreboard

# Update Loop
update do
	change_dir()
	if tick % (@food_spawn_time * 60).to_i == 0 then
		spawn_food()
	end

	if tick % @move_time == 0 then
		eat()
		crash()
		move()
		spawn_food_tick += tick
	end
	
	tick += 1

end



show

