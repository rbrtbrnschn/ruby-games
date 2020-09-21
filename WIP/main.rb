#!/usr/bin/env ruby
require "ruby2d"

set( { :width => 800, :height => 800, :background => "brown"})
@x = 0
@y = 0
tick = 0

@coins = []
@speed = 5
@padding = 0

hero = Sprite.new(
	"hero.png",
	x: @x,
	y: @y,
	z: 1,
	width: 78,
	height: 99,
	clip_width: 78,
	time: 250,
	animations: {
		walk: 1..2,
		climb: 3..4,
		cheer: 5..6
	}
)
def tick()
	if tick % 60 == 0
	then
		tick = 0
		add_coin()
	end
end

def add_coin()
	clip_width = 84	
	coin = Sprite.new(
  	'coin.png',
		x: (rand(Window.width - clip_width)/clip_width).to_i * clip_width,
		y: (rand(Window.height - clip_width)/clip_width).to_i * clip_width,
  	clip_width: clip_width,
  	time: 300,
	  loop: true
	)
	@coins.push(coin)
end

on :key_held do |event|
  # A key was pressed
  key = event.key
	case key
	when "w"
		@y -= 5 if hero.y  > 0
	when "s"
		@y += @speed if hero.y < Window.height - hero.height - @padding
	when "a"
		hero.play animation: :walk, flip: :horizontal
		@x -= @speed if hero.x > 0
	when "d"
		hero.play animation: :walk
		@x += @speed if hero.x < Window.width - hero.width - @padding
	end	
end


update do
	hero.y = @y
	hero.x = @x
	tick += 1
	
	if tick % 60 == 0
	then
		add_coin()
		tick = 0
	end
	

end

show

