# シーン - メニュー
# タイトル画面に戻れる
class Menu
  def initialize
    @@menu = Sprite.new(7, 2, "<MENU>")
    @@msg1 = "go back game "
    @@msg2 = "exit game"
    @@text1 = Sprite.new(4, 5, ">  " + @@msg1)
    @@text2 = Sprite.new(4, 6, "   " + @@msg2)
    @@cursor = 0
  end

  class << self
    def update
      Scene.back if Key.down?(Key::ESCAPE)
      @@cursor = 1 if @@cursor == 0 && Key.down?(Key::DOWN)
      @@cursor = 0 if @@cursor == 1 && Key.down?(Key::UP)
      if @@cursor == 0
        @@text1.text = ">  " + @@msg1
        @@text2.text = "   " + @@msg2
      else
        @@text1.text = "   " + @@msg1
        @@text2.text = ">  " + @@msg2
      end
      Scene.back if Key.down?(Key::RETURN) && @@cursor == 0
      Scene.select(0, init: true) if Key.down?(Key::RETURN) && @@cursor == 1
    end

    def draw
      # プレイ画面にフローするかたちで描画
      # --- draw data ---
      print "   MARIO            WORLD  TIME\n   "
      (6 - $score.to_s.length).times do# 0の数を調整
        print "0"
      end
      print "#{$score}  ◎×"
      if $coin.to_s.length == 1# 0の数を調整
        print "0"
      end
      print "#{$coin}    1-1    "
      (3 - $time.to_s.length).times do# 0の数を調整
        print "0"
      end
      puts "#{$time}"
      
      # --- draw render map ---
      draw = [@@menu, @@text1, @@text2, Play.mario, Play.enemies, Play.block, Play.hatena, Play.mushroom, Play.flag, Play.dokan, Play.wall]
      oy = Play.map.height - HEIGHT
      if Play.mario.x < WIDTH / 2
        ox = 0
      elsif Play.mario.x > Play.map.width - 1 - WIDTH / 2
        ox = Play.map.width - WIDTH
      else
        ox = Play.mario.x - WIDTH / 2
      end
      @@menu.x = ox + 7
      @@text1.x = ox + 4
      @@text2.x = ox + 4
      @@menu.y = oy + 2
      @@text1.y = oy + 5
      @@text2.y = oy + 6
      Play.map.render_draw(ox, oy, WIDTH, HEIGHT, draw)
    end
  end
end
