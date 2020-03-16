# タイトルとライフ表示

# シーン - タイトル
class Title
  def initialize
    @@screen = Map.new(map: [
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    ], text_hash: {0 => "  ", 1 => "■", 2 => "ｃ", 3 => "//"}, width: WIDTH, height: HEIGHT)
    @@text1 = "1 PLAYER GAME"
    @@text2 = "2 PLAYER GAME"
    @@text_1p = Sprite.new(4, 7, "   " + @@text1)
    @@text_2p = Sprite.new(4, 8, "   " + @@text2)
    @@top = Sprite.new(4, 10, "   TOP-0000000")
    @@cursor = 0
    $life = 3
    $player = 1
  end

  class << self
    def update
      @@cursor = 1 if @@cursor == 0 && Key.down?(Key::DOWN)
      @@cursor = 0 if @@cursor == 1 && Key.down?(Key::UP)
      if @@cursor == 0
        @@text_1p.text = ">  " + @@text1
        @@text_2p.text = "   " + @@text2
      else
        @@text_1p.text = "   " + @@text1
        @@text_2p.text = ">  " + @@text2
      end
      if Key.down?(Key::RETURN)
        $player = @@cursor + 1
        Scene.next(init: true)
      end
    end
  
    def draw
      puts "   MARIO            WORLD  TIME"
      puts "   000000  ◎×00    1-1    000"
      @@screen.draw([@@text_1p, @@text_2p, @@top])
    end
  end
end

# シーン - ライフの表示
class Life
  def initialize
    @@screen = Map.new(width: WIDTH, height: HEIGHT)
    @@text1 = Sprite.new(7, 6, "ｃ × #{$life}")
    @@count = 0
  end

  class << self
    def update
      Scene.select(4, init: true) if $life < 0 # Game Over
      @@count += 1
      Scene.back(init: true) if Key.down?(Key::ESCAPE)
      Scene.next(init: true) if @@count >= 10
    end

    def draw
      puts "   MARIO            WORLD  TIME"
      puts "   000000  ◎×00    1-1    000"
      @@screen.draw([@@text1])
    end
  end
end
