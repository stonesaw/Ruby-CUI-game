#ruby -Ku
require_relative './../Monochrome-Ruby.rb'

map = Map.new(text_hash: {0 => "・"}, width: 32, height: 16)
maru = Sprite.new(2, 2, "○")
sikaku = Sprite.new(10, 6, ["□□", "□□"])

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)
  
  sikaku.x += 1 if Key.down?(Key::RIGHT)
  sikaku.x -= 1 if Key.down?(Key::LEFT)
  sikaku.y += 1 if Key.down?(Key::DOWN)
  sikaku.y -= 1 if Key.down?(Key::UP)

  maru.x += 1 if Key.down?("d")
  maru.x -= 1 if Key.down?("a")
  maru.y += 1 if Key.down?("s")
  maru.y -= 1 if Key.down?("w")

  map.draw([maru, sikaku])
  puts "maru(#{maru.x}, #{maru.y})"
  puts "sikaku(#{sikaku.x}, #{sikaku.y})"
  puts "maru touch head!" if maru.touch_head(sikaku)
  puts "maru touch foot!" if maru.touch_foot(sikaku)
  puts "maru touch right!" if maru.touch_right(sikaku)
  puts "maru touch left!" if maru.touch_left(sikaku)
  puts "hit!" if maru === sikaku

end