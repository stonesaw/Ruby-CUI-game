#ruby -Ku
require_relative './../Monochrome-Ruby'

map = Map.new(text_hash: {0 => "　"}, width: 32, height: 32)
text = Sprite.new(map.width / 2, map.height / 2, "Hello MonoChrome Ruby!")
text.x -= (text.width / 2)
wall_text = "::"
walls = []
map.width.times do |x|
  2.times do |y|
    if y == 0
      walls << Sprite.new(x, y, wall_text)
    else
      walls << Sprite.new(x, map.height - 1, wall_text)
    end
  end
end
(map.height - 2).times do |y|
  2.times do |x|
    if x == 0
      walls << Sprite.new(0, y + 1, wall_text)
    else
      walls << Sprite.new(map.width - 1, y + 1, wall_text)
    end
  end
end

dx = -1
dy = 1

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)

  text.x += dx
  if text === walls
    text.x -= 2*dx
    dx = -dx
  end
  
  text.y += dy
  if text === walls
    text.y -= 2*dy
    dy = -dy
  end

  map.draw([text, walls])
end
