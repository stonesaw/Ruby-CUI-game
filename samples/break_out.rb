#ruby -Ku
# break out - ブロック崩し
require './../class'

Map.new([[]], {0 => "・"}, width: 32, height: 24)

bar = Sprite.new(20, 23, "<---->")

walls = []
Map.height.times do |i|
    walls << Sprite.new(0, i, "□")
    walls << Sprite.new(Map.width - 1, i, "□")
end
(Map.width - 2).times do |i|
    walls << Sprite.new(i + 1, 0, "□")
end

ball = Sprite.new(Map.width / 2, Map.height / 2, "○")
dx = 1
dy = -1

blocks = []
5.times do |y|
    ((Map.width / 2) - 2).times do |x|
        blocks << Sprite.new(2 + x * 2 , 2 + y * 2, "■ a")
    end
end

loop do
    Map.update
    Key.update

    break if Key.down?(Key::ESCAPE)

    bar.x += 1 if Key.down?("2")
    bar.x -= 1 if Key.down?("1")
    
    ball.x += dx
    if ball === walls
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
    if ball === walls
        ball.y -= dy
        dy = -dy
    end
    
    col_y = ball.check(blocks).first
    if col_y
        col_y.vanish
        ball.y -= dy
        dy = -dy
    end

    
    bar.draw
    Sprite.draw(walls)
    ball.draw
    
    Sprite.draw(blocks)
    Map.draw

    p blocks[0].width
    sleep(0.1)

    if ball.y > Map.height
        puts "GAME OVER!"
        break
    end
end