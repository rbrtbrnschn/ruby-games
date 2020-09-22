require "ruby2d"
require "./Game"
require "./Snek"


# Window
window_width = 800
window_height = 800
set ({ width: window_width, height: window_height, background: "navy", resizable: true, fps_cap:60})

# Board
board_width = 700
board_height = 450
board_margin_top = 300
board_margin_sides = 50
grid_size = 25
# Setup
game = Game.new
snek = Snek.new board_margin_sides, board_margin_top, board_width, board_height, grid_size

update do
	clear
	game.draw board_margin_sides, board_margin_top, board_width, board_height
	unless game.finished?
		snek.move
	end
	snek.draw
	
	on :key_down do |event|
		if ["w","a","s","d"].include? event.key then
			if snek.change_dir_possible? event.key then
				snek.change_dir event.key
			end
		end
	end
end


show
