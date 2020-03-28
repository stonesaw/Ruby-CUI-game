#ruby -Ku
require_relative './../Monochrome-Ruby'

# マップの値をシンボルにする際のサンプル
# 実行結果は'tutorial/display-ans.rb'と同様
# 沢山の項目を管理する際にはシンボル名で管理できるのでおすすめ
# 今回は全ての値をシンボルにしているが一部だけ使用することも可能

display = Map.new(
map: [
    [:emp, :top, :top, :top, :emp],
    [:tle, :emp, :emp, :emp, :tri],
    [:tle, :emp, :emp, :emp, :tri],
    [:tle, :emp, :emp, :emp, :tri],
    [:emp, :cen, :cen, :cen, :emp],
    [:ble, :emp, :emp, :emp, :bri],
    [:ble, :emp, :emp, :emp, :bri],
    [:ble, :emp, :emp, :emp, :bri],
    [:emp, :btm, :btm, :btm, :emp]
], text_hash: {
  emp: "  ", 
  top: "□",
  tle: "□", 
  tri: "□",
  cen: "□", 
  ble: "□", 
  bri: "□", 
  btm: "□"
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
  display.text = [:top, off]
  display.text = [:tri, off]
  display.text = [:tle, off]
  display.text = [:cen, off]
  display.text = [:ble, off]
  display.text = [:bri, off]
  display.text = [:btm, off]

  # numによってonにするテキストを変える
  display.text = [:top, on] if num != 1 && num != 4
  display.text = [:tle, on] if num == 8 || num == 0 || num == 4 || num == 5 || num == 6 || num == 9
  display.text = [:tri, on] if num != 5 && num != 6
  display.text = [:cen, on] if num != 0 && num != 1 && num != 7
  display.text = [:ble, on] if num == 8 || num == 0 || num == 2 || num == 6
  display.text = [:bri, on] if num != 2
  display.text = [:btm, on] if num != 1 && num != 4 && num != 7

  # 描画
  display.draw
end