#ruby -Ku
require_relative './../Monochrome-Ruby'

# 7セグメントディスプレイ
# 時計のディスプレイ(1文字だけ)を作る

# --- 解答例 ---

# チャレンジ！
# 数字を4つにして時刻を表示してみる

display = Map.new(
map: [
    [0, 1, 1, 1, 0],
    [2, 0, 0, 0, 3],
    [2, 0, 0, 0, 3],
    [2, 0, 0, 0, 3],
    [0, 4, 4, 4, 0],
    [5, 0, 0, 0, 6],
    [5, 0, 0, 0, 6],
    [5, 0, 0, 0, 6],
    [0, 7, 7, 7, 0]
], text_hash: {
  0 => "  ", 
  1 => "□", 
  2 => "□", 
  3 => "□", 
  4 => "□", 
  5 => "□", 
  6 => "□", 
  7 => "□", 
  8 => "□", 
  9 => "□"
  })

num = 8
on = "■"
off = "□"

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)

  # 入力
  num = 0 if Key.down?("0")
  num = 1 if Key.down?("1")
  num = 2 if Key.down?("2")
  num = 3 if Key.down?("3")
  num = 4 if Key.down?("4")
  num = 5 if Key.down?("5")
  num = 6 if Key.down?("6")
  num = 7 if Key.down?("7")
  num = 8 if Key.down?("8")
  num = 9 if Key.down?("9")

  # リセット
  display.text = [1, off]
  display.text = [2, off]
  display.text = [3, off]
  display.text = [4, off]
  display.text = [5, off]
  display.text = [6, off]
  display.text = [7, off]

  # numによってonにするテキストを変える
  display.text = [1, on] if num != 1 && num != 4
  display.text = [2, on] if num == 8 || num == 0 || num == 4 || num == 5 || num == 6 || num == 9
  display.text = [3, on] if num != 5 && num != 6
  display.text = [4, on] if num != 0 && num != 1 && num != 7
  display.text = [5, on] if num == 8 || num == 0 || num == 2 || num == 6
  display.text = [6, on] if num != 2
  display.text = [7, on] if num != 1 && num != 4 && num != 7

  # 描画
  display.draw
end