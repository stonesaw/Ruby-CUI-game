#ruby -Ku
# break out - ブロック崩し
require './../Monochrome-Ruby'

map = Map.new(text_hash: {0 => "・"}, width: 32, height: 24)

bar = Sprite.new(20, 22, "<---->")

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
5.times do |y|
  ((map.width / 2) - 2).times do |x|
    blocks << Sprite.new(2 + x * 2 , 2 + y * 2, "■■")
  end
end

loop do
  Key.update

  break if Key.down?(Key::ESCAPE)

  bar.x += 2 if Key.down?("2")
  bar.x -= 2 if Key.down?("1")

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

  map.draw([bar, walls, ball, blocks])

  if ball.y > map.height
    puts "GAME OVER!"
    break
  end

  p "ball x: #{ball.x}, y: #{ball.y}"
  p "bar x: #{bar.x}, y: #{bar.y}, width: #{bar.width}"

  sleep(0.1)
  system("cls")
end