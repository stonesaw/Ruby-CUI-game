#ruby -Ku
require_relative './../Monochrome-Ruby.rb'

# 当たり判定のサンプル

map = Map.new(text_hash: {0 => "・"}, width: 32, height: 16)
maru = Sprite.new(2, 2, "○")
sikaku = Sprite.new(10, 6, ["□□", "□□"])

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)
  
  # 丸の移動(WASD)
  maru.x += 1 if Key.down?("d")
  maru.x -= 1 if Key.down?("a")
  maru.y += 1 if Key.down?("s")
  maru.y -= 1 if Key.down?("w")
  
  # 四角の移動(方向キー)
  sikaku.x += 1 if Key.down?(Key::RIGHT)
  sikaku.x -= 1 if Key.down?(Key::LEFT)
  sikaku.y += 1 if Key.down?(Key::DOWN)
  sikaku.y -= 1 if Key.down?(Key::UP)

  map.draw([maru, sikaku])
  
  puts "maru(#{maru.x}, #{maru.y})"
  puts "sikaku(#{sikaku.x}, #{sikaku.y})"

  puts "--- maru ---"
  if maru === sikaku
    puts " hit!"
  elsif maru.touch_head(sikaku)
    puts " touch head!"
  elsif maru.touch_foot(sikaku)
    puts " touch foot!"
  elsif maru.touch_right(sikaku)
    puts " touch right!"
  elsif maru.touch_left(sikaku)
    puts " touch left!"
  else
    puts " none!"
  end
end