#ruby -Ku
require_relative './../Monochrome-Ruby'

# 7セグメントディスプレイ
# 時計のディスプレイ(1文字だけ)を作る

# このプログラムを発展させてキーボードの数字が押されたときにその数を表示させよう！

display = Map.new(
map: [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
], text_hash: {0 => "  ", 1 => "□"})

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)

  display.draw
end
