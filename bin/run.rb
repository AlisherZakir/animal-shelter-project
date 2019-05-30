require_relative '../config/environment'
require_relative '../db/seeds.rb'

#Ui example
# require_relative '../examples/ui.rb'

# require_relative '../examples/cmd_tracker.rb'

#Doesn't work
# require_relative '../demos/lp/main.rb'

# Terminal.run

# RuTui::Theme.use :dark



screen = RuTui::Screen.new

size = RuTui::Screen.size

screen.add_static RuTui::Text.new({ :x => size[1]/2-30, :y  => 2, :text => "use the cursor keys to choose the sprite or q/CTRL+C to quit" })

res_dir = File.dirname(__FILE__) + '/'

sprites = RuTui::Sprite.new({ :x => size[1]/2-6, :y => 5, :file => res_dir + 'space-invader_sprite.axx' })
screen.add sprites

Thread.new {
	while true
		sprites.update
		RuTui::ScreenManager.draw
	end
}


RuTui::ScreenManager.loop({ :autofit => true, :autodraw => false }) do |key|


	break if key == :ctrl_c or key == "q"

	# We can translate the key symbol to a string to set the sprite
	if [:up, :down, :left, :right].include? key
		sprites.set_current key.to_s
	end
end



# RuTui::Theme.use :basic
# screen = RuTui::Screen.new
#
# RuTui::ScreenManager.add :default, screen
# RuTui::ScreenManager.set_current :default
#
# size = RuTui::Screen.size
# map = [[0,0,0],[0,0,0],[0,0,0]]
# current = "X"
# pos = [0,0]
#
# screen.add_static RuTui::Text.new({
# 	:x => (size[1]/2)-3,
# 	:y => 2,
# 	:text => "This is a heading i think",
# 	:foreground => 15 })
#
# screen.add_static RuTui::Text.new({
# 	:x => (size[1]/2)-2,
# 	:y => 4,
# 	:text => "go lower",
# 	:foreground => 244 })
#
# screen.add_static RuTui::Text.new({
# 		:x => (size[1]/2)-2,
# 		:y => 4.5,
# 		:text => "do you see these?",
# 		:foreground => 244 })
#
# screen.add_static RuTui::Text.new({
# 	:x => (size[1]/2)-2,
# 	:y => 15,
# 	:text => "go lower",
# 	:foreground => 244 })
#
# screen.add info = RuTui::Text.new({
# 	:x => (size[1]/2)-3,
# 	:y => 12,
# 	:text => "#{rand(5)} no it doesnt",
# 	:foreground => 250 })
#
#
# hor = RuTui::Pixel.new(RuTui::Theme.get(:border).fg, RuTui::Theme.get(:background).bg, "+")
# ver = RuTui::Pixel.new(RuTui::Theme.get(:border).fg, RuTui::Theme.get(:background).bg, "+")
# cor = RuTui::Pixel.new(RuTui::Theme.get(:border).fg, RuTui::Theme.get(:background).bg, "+")
#
# xhor = RuTui::Pixel.new(RuTui::Theme.get(:textcolor), RuTui::Theme.get(:background).bg, "+")
# xver = RuTui::Pixel.new(RuTui::Theme.get(:textcolor), RuTui::Theme.get(:background).bg, "+")
# xcor = RuTui::Pixel.new(RuTui::Theme.get(:textcolor), RuTui::Theme.get(:background).bg, "+")
#
# sprite = RuTui::Sprite.new({ :x => 3, :y => 5, :file => 'space-invader_sprite.axx' })
#
# screen.add sprite
#
# 3.times do |ir|
# 	3.times do |ic|
# 		screen.add_static RuTui::Box.new({
# 			:x => (size[1]/2)+(ic*4-4),
# 			:y => 5+(ir*2),
# 			:width => 5,
# 			:height => 3,
# 			:horizontal => hor,
# 			:vertical => ver,
# 			:corner => cor })
# 	end
# end
#
# screen.add box0 = RuTui::Box.new({
# 	:x => (size[1]/2)-4,
# 	:y => 5,
# 	:width => 5,
# 	:height => 3,
# 	:horizontal => xhor,
# 	:vertical => xver,
# 	:corner => xcor })
#
#
# RuTui::ScreenManager.loop({ :autodraw => true }) do |key|
#
# 	if key == "q" or key == :ctrl_c # CTRL+C
# 		break
#
# 	elsif key == " " # space bar
# 		if map[pos[0]][pos[1]] == 0
# 			color = RuTui::Theme.get(:rainbow)[1] if current == "X"
# 			color = RuTui::Theme.get(:rainbow)[0] if current == "O"
#
# 			screen.add RuTui::Text.new({
# 				:x => (size[1]/2)+(pos[0]*4-4)+2,
# 				:y => 5+(pos[1]*2)+1,
# 				:text => current,
# 				:foreground => color })
#
# 			map[pos[0]][pos[1]] = current.dup
#
# 			# Simple all possibilities, not that much so ....
# 			(info.set_text "#{current} WON! yay!"; RuTui::ScreenManager.draw; break) if (map[0][0] == "X")
#
# 			if current == "X"
# 				current = "O"
# 			else
# 				current = "X"
# 			end
#
# 			info.set_text "Random number is  #{rand(5)}"
# 		end
#
# 	elsif key == 'w' or key == :up # up
# 		(box0.move(0,-4); pos[1] -= 1) if pos[1] > 0
# 	elsif key == 's' or key == :down # down
# 		(box0.move(0,4); pos[1] += 1) if pos[1] < 2
# 	elsif key == 'd' or key == :right # right
# 		(box0.move(8,0); pos[0] += 1) if pos[0] < 2
# 	elsif key == 'a' or key == :left # left
# 		(box0.move(-8,0); pos[0] -= 1) if pos[0] > 0
# 	end
# end
#
# print RuTui::Ansi.foreground("b")


# screen = RuTui::Screen.new
#
# sprite = RuTui::Sprite.new({ :x => 3, :y => 5, :file => 'space-invader_sprite.axx' })
#
# sprite.set_position(15,15)
#
# screen.add(sprite)
#
# RuTui::ScreenManager.add :default, screen
#
# RuTui::Circle.new({ :x => 10, :y => 20, :radius => 10 })
#
#
# # RuTui::Figlet.add :test, "path/to/font.flf"
# header = RuTui::Figlet.new({ :text => "Meh", :font => :test, :rainbow => true })
#
# textfield = RuTui::Textfield.new({ :x => 1, :y => 1 })

# textfield.set_focus
# RuTui::ScreenManager.loop do |key|
#   textfield.write key
# end

# RuTui::ScreenManager.loop({ :autofit => true, :autodraw => false }) do |key|
# 	break if key == 3 or key.chr == "q" # 3 = CTRL+C
# end


# Pry.start
#
#
# puts "hello world"
