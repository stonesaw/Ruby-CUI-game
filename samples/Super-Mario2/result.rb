class GameOver
  def initialize
    @@screen = Map.new(map: [
      [3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3]
    ], text_hash: {0 => "  ", 1 => "ー", 2 => "｜", 3 => "＋"})
    @@over = Sprite.new(6, 2, "GAME OVER!")
    @@msg1 = "more playing!"
    @@msg2 = "exit!"
    @@text1 = Sprite.new(4, 5, ">  " + @@msg1)
    @@text2 = Sprite.new(4, 6, "   " + @@msg2)
    @@cursor = 0
  end

  class << self
    def update
      Scene.close if Key.down?(Key::ESCAPE)
      @@cursor = 1 if @@cursor == 0 && Key.down?(Key::DOWN)
      @@cursor = 0 if @@cursor == 1 && Key.down?(Key::UP)
      if @@cursor == 0
        @@text1.text = ">  " + @@msg1
        @@text2.text = "   " + @@msg2
      else
        @@text1.text = "   " + @@msg1
        @@text2.text = ">  " + @@msg2
      end
      if Key.down?(Key::RETURN)
        Scene.select(0, init: true) if @@cursor == 0
        Scene.close if @@cursor == 1
      end
    end

    def draw
      @@screen.draw([@@over, @@text1, @@text2])
    end
  end
end

class GameClear
  def initialize
    @@screen = Map.new(map: [
      [3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
      [3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3]
    ], text_hash: {0 => "  ", 1 => "ー", 2 => "｜", 3 => "＋"})
    @@clear = Sprite.new(6, 2, "GAME CLEAR! ")
    @@msg1 = "more playing!"
    @@msg2 = "exit!"
    @@text1 = Sprite.new(4, 5, ">  " + @@msg1)
    @@text2 = Sprite.new(4, 6, "   " + @@msg2)
    @@cursor = 0
  end

  class << self
    def update
      Scene.close if Key.down?(Key::ESCAPE)
      @@cursor = 1 if @@cursor == 0 && Key.down?(Key::DOWN)
      @@cursor = 0 if @@cursor == 1 && Key.down?(Key::UP)
      if @@cursor == 0
        @@text1.text = ">  " + @@msg1
        @@text2.text = "   " + @@msg2
      else
        @@text1.text = "   " + @@msg1
        @@text2.text = ">  " + @@msg2
      end
      if Key.down?(Key::RETURN)
        Scene.select(0, init: true) if @@cursor == 0
        Scene.close if @@cursor == 1
      end
    end

    def draw
      @@screen.draw([@@clear, @@text1, @@text2])
    end
  end
end
