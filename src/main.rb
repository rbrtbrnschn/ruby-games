require "ruby2d"
require "./Game"
require "./Snek"


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
