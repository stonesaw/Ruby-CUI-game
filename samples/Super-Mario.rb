#ruby -Ku
require_relative './../Monochrome-Ruby'

# 2次元配列[height][width] を作成
map = Map.new(text_hash: {0 => "　"}, width: 168, height: 20)
# マリオ
me = Sprite.new(1, 5, ["ｃ", "人"])

# 敵(クリボー)
enemies = []
enemies << Sprite.new(14, map.height - 2, "▲")
enemies << Sprite.new(30, 0, "▲")

# --- ブロック生成 ---
# 地面
walls = []
map.width.times do |i|
  next if (i == 42 || i == 43)
  next if (59 <= i && i <= 61)
  next if (124 <= i && i <= 125)
  walls << Sprite.new(i, map.height - 1, "■")
end

h_nomal = map.height - 5# ブロックの基本の高さ
h_high = map.height - 10# 高いブロックの高さ

# 壊せるブロック
block = [
  Sprite.new(8, h_nomal, "□"),
  Sprite.new(10, h_nomal, "□"),
  Sprite.new(12, h_nomal, "□"),
  Sprite.new(50, h_nomal, "□"),
  Sprite.new(52, h_nomal, "□"),
  Sprite.new(64, h_high, "□"),
  Sprite.new(65, h_high, "□"),
  Sprite.new(66, h_high, "□"),
  Sprite.new(67, h_nomal, "□"),
  Sprite.new(72, h_nomal, "□"),
  Sprite.new(90, h_nomal, "□"),
  Sprite.new(93, h_high, "□"),
  Sprite.new(94, h_high, "□"),
  Sprite.new(95, h_high, "□"),
  Sprite.new(100, h_high, "□"),
  Sprite.new(101, h_nomal, "□"),
  Sprite.new(102, h_nomal, "□"),
  Sprite.new(103, h_high, "□"),
  Sprite.new(139, h_nomal, "□"),
  Sprite.new(140, h_nomal, "□"),
  Sprite.new(142, h_nomal, "□")
]
8.times do |x|
  block << Sprite.new(53 + x, h_high, "□")
end

# ハテナブロック
hatena = []
hatena << Sprite.new(5, h_nomal, "？")
hatena << Sprite.new(9, h_nomal, "？")
hatena << Sprite.new(10, h_high, "？")
hatena << Sprite.new(11, h_nomal, "？")
hatena << Sprite.new(51, h_nomal, "？")
hatena << Sprite.new(67, h_high, "？")
hatena << Sprite.new(73, h_nomal, "□")# 隠れスター
hatena << Sprite.new(78, h_nomal, "？")
hatena << Sprite.new(81, h_nomal, "？")
hatena << Sprite.new(81, h_high, "？")
hatena << Sprite.new(84, h_nomal, "？")
hatena << Sprite.new(101, h_high, "？")
hatena << Sprite.new(102, h_high, "？")
hatena << Sprite.new(141, h_nomal, "？")

# 土管
dokan = []
dokan << Sprite.new(15, map.height - 4, ["|==|", " || ", " || "])
dokan << Sprite.new(23, h_nomal, ["|==|", " || ", " || ", " || "])
dokan << Sprite.new(32, h_nomal, ["|==|", " || ", " || ", " || "])
dokan << Sprite.new(133, map.height - 3, ["|==|", " || "])
dokan << Sprite.new(149, map.height - 3, ["|==|", " || "])

# 階段
2.times do |i|
  pos = 105 if i == 0
  pos = 119 if i == 1
  4.times do |x|
    (x+1).times do |y|
      walls << Sprite.new(pos + x, map.height - 2 - y, "■")
    end
  end
end
4.times do |y|
  walls << Sprite.new(123, map.height - 2 - y, "■")
end
# 階段(下り)
2.times do |i|
  pos = 111 if i == 0
  pos = 126 if i == 1
  4.times do |x|
    y = 4
    (y - x).times do
      walls << Sprite.new(pos + x, map.height - 6 + y, "■")
      y -= 1
    end
  end
end
# 最後の階段
6.times do |x|
  (x + 1).times do |y|
    walls << Sprite.new(152 + x, map.height - 2 - y, "■")
  end
end
6.times do |y|
  walls << Sprite.new(158, map.height - 2 - y, "■")
end

# 旗
flag = []
7.times do |i|
  flag << Sprite.new(map.width - 2, map.height - 3 - i, "| ")
end
flag << Sprite.new(map.width - 2, h_high, "▶ ")
walls << Sprite.new(map.width - 2, map.height - 2, "■")

# --- Var ---
flg = 0
score = 0
coin = 0
jump = 0
power_up = 0
# render_drawで使う
ren_width = 19
ren_center = ren_width / 2
ren_height = 17

# main loop
loop do
  Key.update
  # --------

  system("cls")
  break if Key.down?(Key::ESCAPE)

  me.x += 1 if Key.down?("d") && !me.touch_right(walls) && !me.touch_right(dokan)
  me.x -= 1 if Key.down?("a") && !me.touch_left(walls) && !me.touch_left(dokan)

  me.x = 0 if me.x < 0
  me.x = (map.width - 1) if me.x >= map.width

  power_up = 1 if Key.down?("1")
  power_up = 0 if Key.down?("0")

  me.text = ["ｃ"] if power_up == 0
  me.text = ["ｃ", "人"] if power_up == 1
  # jump
  if me.touch_foot(walls) || me.touch_foot(block) || me.touch_foot(hatena) || me.touch_foot(dokan)
    jump = 1 if Key.down?(Key::SPACE)
  else
    # 重力
    me.y += 1
  end

  if 0 < jump && jump < 3
    me.y -= 3
    jump += 1
  elsif jump == 3
    me.y -= 2
    jump = 0 
  end

  # ブロックをたたく
  if jump > 0 && (me.touch_head(block) || me === block)
    jump = 0
    col = me.check(block, y: -1).first
    col.vanish if col
    Sprite.clean(block)
  end
  # ハテナブロックをたたく
  if jump > 0 && (me.touch_head(hatena) || me === hatena)
    jump = 0
    col = me.check(hatena, y: -1).first
    if col
      if col.text == "？"
        p "a"
        col.text = "■"
        coin += 1
      end
    end
  end
    
  # enemies.length.times do |i|
  #   if !(enemies[i].touch_foot(walls))
  #     enemies[i].y += 1
  #   end
  # end
  
  # 敵を踏む
  if me.touch_foot(enemies)
    col = me.check(enemies, y: 1).first
    if col.nil? == false
      col.vanish
      score += 100
    end
    Sprite.clean(enemies)
  end

  # draw
  if me === enemies || me.touch_right(enemies) || me.touch_left(enemies) || me.y > map.height - 2
    puts "============"
    puts " GAME OVER!"
    puts "============"
    me.text = "×" if power_up == 0
    me.text = ["×", "人"] if power_up == 1
    flg = 1
  end
  if me === flag
    puts "============="
    puts " GAME CLEAR!"
    puts "============="
    flg = 1
  end
  puts "score : #{score}  coin × #{coin}"

  draw = [me, enemies, block, hatena, flag, dokan, walls]

  if me.x < ren_center
    map.render_draw(0, map.height - ren_height, ren_width, ren_height, draw)
  elsif me.x > map.width - 1 - ren_center
    map.render_draw(map.width - ren_width, map.height - ren_height, ren_width, ren_height, draw)
  else
    map.render_draw(me.x - ren_center, map.height - ren_height, ren_width, ren_height, draw)
  end

  puts "x: #{me.x}, y: #{me.y} "

  break if flg == 1
end
