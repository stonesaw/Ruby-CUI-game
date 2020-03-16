# シーン - メニュー
# タイトル画面に戻れる
class Menu
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
      @@screen.draw([@@menu, @@text1, @@text2])
    end
  end
end
