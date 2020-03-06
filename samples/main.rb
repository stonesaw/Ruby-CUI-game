#ruby -Ku

require_relative './../Monochrome-Ruby'

Map.new(text_hash: {0 => "・"}, width: 60, height: 10)

me = Sprite.new(0, 0, "ｃ")
enemies = []
enemies << Sprite.new(Map.width / 2, Map.height / 2, "▲")
enemies << Sprite.new(Map.width / 2 + 5, 0, "▲")

walls = []
Map.width.times do |i|
    # next if (i == 10 || i == 16)
    walls << Sprite.new(i, Map.height - 1, "■")
end

g = 1
flg = 0
score = 0

# main loop
loop do
    # --------
    Map.update
    Key.update
    # --------

    # code
    break if Key.down?(Key::ESCAPE)

    me.x += 1 if Key.down?("d")
    me.x -= 1 if Key.down?("a")
    
    if me.touch_foot(walls)
        me.y -= 4 if Key.down?(" ")
    else
        me.y += g
    end
    
    enemies.length.times do |i|
        if !(enemies[i].touch_foot(walls))
            enemies[i].y += g
        end
    end

    if me.touch_foot(enemies)
        me.y += 1
        col = me.check(enemies).first
        if col.nil? == false
            col.vanish
            score += 100
        end
    end
    Sprite.clean(enemies)

    break if (me.x >= Map.width) || (me.y >= Map.height) || (me.x < 0) || (me.y < 0)
    if me === enemies
        puts "GAME OVER!"
        me.text = "×"
        flg = 1
    end

    puts "score : #{score}"
    Sprite.draw(walls)
    me.draw
    Sprite.draw(enemies)
    Map.draw
    sleep(0.01)

    break if flg == 1
end
