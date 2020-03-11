#ruby -Ku
# ブロック崩し
# カーソルキーで移動
require './../Monochrome-Ruby'

map = Map.new(text_hash: {0 => "  "}, width: 32, height: 24)
bar = Sprite.new(20, 22, "<========>")

walls = []
map.height.times do |i|
  walls << Sprite.new(0, i, "□")
  walls << Sprite.new(map.width - 1, i, "□")
end
(map.width - 2).times do |i|
  walls << Sprite.new(i + 1, 0, "□")
end

ball = Sprite.new(map.width / 2, map.height / 2, "○")
dx = 1
dy = -1

blocks = []
4.times do |y|
  ((map.width - 4) / 4).times do |x|
    blocks << Sprite.new(2 + x * 4 , 2 + y * 2, "('-ω-`)")
  end
end

flg = 0

loop do
  Key.update
  break if Key.down?(Key::ESCAPE)

  if Key.down?(Key::RIGHT) && !bar.touch_right(walls)
    bar.x += 3
    while bar === walls
      bar.x -= 1
    end
  end
  if Key.down?(Key::LEFT) && !bar.touch_left(walls)
    bar.x -= 3
    while bar === walls
      bar.x += 1
    end
  end

  ball.x += dx
  if (ball === walls || ball === bar)
    ball.x -= dx
    dx = -dx
  end
  
  col_x = ball.check(blocks).first
  if col_x
    col_x.vanish
    ball.x -= dx
    dx = -dx
  end
  Sprite.clean(blocks)
  
  ball.y += dy
  if (ball === walls || ball === bar)
    ball.y -= dy
    dy = -dy
  end
  
  col_y = ball.check(blocks).first
  if col_y
    col_y.vanish
    ball.y -= dy
    dy = -dy
  end
  Sprite.clean(blocks)
  
  if blocks.length == 0
    flg = 1
    puts "============="
    puts " GAME CLEAR!"
    puts "============="
  elsif ball.y >= map.height - 1
    ball.text = "×"
    flg = 1
    puts "============"
    puts " GAME OVER!"
    puts "============"
  end
  
  puts "block : #{blocks.length}"
  map.draw([bar, walls, ball, blocks])

  break if flg == 1
  system("cls")
end
