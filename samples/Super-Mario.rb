#ruby -Ku
require_relative './../Monochrome-Ruby'

# スーパーマリオ(簡易版)

# class 自機
class Me < Sprite
  def initialize(x, y, text, state = 0)
    super(x, y, text)
    @state = state
    @jump = 0
  end

  def update
    # ジャンプ
    if self.touch_foot($wall) || self.touch_foot($block) || self.touch_foot($hatena) || self.touch_foot($dokan)
      @jump = 1 if Key.down?(Key::SPACE)
    else
      # 重力
      self.y += 1
    end

    if 0 < @jump && @jump < 3
      self.y -= 3
      @jump += 1
    elsif @jump == 3
      self.y -= 2
      @jump = 0
    end

    # ブロックをたたく
    if @jump > 0 && (self.touch_head($block) || self === $block)
      @jump = 0
      col = [
        self.check($block, y: -1).first,
        self.check($block, y: -2).first,
        self.check($block).first
      ].compact!
      unless col == nil
        col.first.vanish
      end
      self.y += 1 if self.state == 1
      Sprite.clean($block)
    end

    # ハテナブロックをたたく
    if @jump > 0 && (self.touch_head($hatena) || self === $hatena)
      @jump = 0
      col = [
        self.check($hatena, y: -1).first,
        self.check($hatena, y: -2).first,
        self.check($hatena).first
      ].compact!
      unless col == nil
        col = col.first
        if col.text[0] == "？" || col.text[0] == "  "
          col.text[0] = "■"
          if col.item == "coin"
            $coin += 1
            $score += 200
          elsif col.item == "mushroom"
            $mushroom << Mushroom.new(col.x, col.y - 1, "茸")
          end
        else
          self.y += 1
        end
      end
      self.y += 1 if self.state == 1
    end

    # キノコを取る
    if self === $mushroom
      col = self.check($mushroom).first
      if col
        col.vanish
        if @state == 0
          @state = 1
          self.y -= 1
        end
        $score += 1000
      end
      Sprite.clean($mushroom)
    end

    self.text = ["ｃ"] if @state == 0
    self.text = ["ｃ", "人"] if @state == 1

    # 敵を踏む
    if self.touch_foot($enemies)
      col = self.check($enemies, y: 1).first
      unless col == nil
        col.vanish
        $score += 100
        self.y -= 2
      end
      Sprite.clean($enemies)
    end

    # 敵との衝突
    if self === $enemies || self.touch_right($enemies) || self.touch_left($enemies)
      if self.state == 0
        puts "============"
        puts " GAME OVER!"
        puts "============"
        self.text = "×"
        self.state = -1
      else
        self.state -= 1
        col = [
          self.check($enemies).first,
          self.check($enemies, x: 1).first,
          self.check($enemies, x: -1).first
        ].compact!
        unless col == nil
          col.first.vanish
          Sprite.clean($enemies)
        end
      end
    end
  end

  def state
    return @state
  end

  def state=(val)
    @state = val
  end
end

# class 敵
class Enemy < Sprite
  def initialize(x, y, text, dx = -1)
    super(x, y, text)
    @dx = dx
  end

  def self.update(sprite)
    sprite.length.times do |i|
      # 向きを変える
      sprite[i].dx = -1 if sprite[i].touch_right($block) || sprite[i].touch_right($hatena) || sprite[i].touch_right($dokan)
      sprite[i].dx = 1 if sprite[i].touch_left($block) || sprite[i].touch_left($hatena) || sprite[i].touch_left($dokan)
      if sprite[i].x >= 0
        if sprite[i].touch_foot($wall) || sprite[i].touch_foot($block) || sprite[i].touch_foot($hatena) || sprite[i].touch_foot($dokan)
          sprite[i].x += sprite[i].dx
        end
      end
    end
  end

  def dx
    return @dx
  end

  def dx=(val)
    @dx = val
  end
end

# class ハテナブロック
class Hatena < Sprite
  def initialize(x, y, text, item)# item => str
    super(x, y, text)
    @item = item
  end

  def item
    return @item
  end
end

# class キノコ
class Mushroom < Sprite
  def initialize(x, y, text, dx = 1)
    super(x, y, text)
    @dx = dx
  end

  def self.update(sprite)
    sprite.length.times do |i|
      # 向きを変える
      sprite[i].dx = -1 if sprite[i].touch_right($block) || sprite[i].touch_right($hatena) || sprite[i].touch_right($dokan)
      sprite[i].dx = 1 if sprite[i].touch_left($block) || sprite[i].touch_left($hatena) || sprite[i].touch_left($dokan)
      
      if sprite[i].touch_foot($wall) || sprite[i].touch_foot($block) || sprite[i].touch_foot($hatena) || sprite[i].touch_foot($dokan)
        sprite[i].x += sprite[i].dx
      else
        sprite[i].y += 1
      end
    end
  end

  def dx
    return @dx
  end

  def dx=(val)
    @dx = val
  end
end

# 2次元配列[height][width] を作成
map = Map.new(width: 190, height: 20)
# 高さ
h_ground = map.height - 2# 地面の高さ
h_nomal = map.height - 5# ブロックの基本の高さ
h_high = map.height - 10# 高いブロックの高さ

# マリオ
mario = Me.new(4, h_ground, "ｃ")
# アイテム
$mushroom = []
star = []
# 敵(クリボー)
$enemies = [
  Enemy.new(29, h_ground, "▲"),
  Enemy.new(42, h_ground, "▲"),
  Enemy.new(49, h_ground, "▲"),
  Enemy.new(50, h_ground, "▲")
]
# --- ブロック生成 ---
# 地面
$wall = []
map.width.times do |i|
  next if (i == 64 || i == 65)
  next if (81 <= i && i <= 83)
  next if (146 <= i && i <= 147)
  $wall << Sprite.new(i, map.height - 1, "■")
end
# 壊せるブロック
$block = [
  Sprite.new(22, h_nomal, "□"),
  Sprite.new(24, h_nomal, "□"),
  Sprite.new(26, h_nomal, "□"),
  Sprite.new(72, h_nomal, "□"),
  Sprite.new(74, h_nomal, "□"),
  Sprite.new(86, h_high, "□"),
  Sprite.new(87, h_high, "□"),
  Sprite.new(88, h_high, "□"),
  Sprite.new(89, h_nomal, "□"),
  Sprite.new(94, h_nomal, "□"),
  Sprite.new(112, h_nomal, "□"),
  Sprite.new(115, h_high, "□"),
  Sprite.new(116, h_high, "□"),
  Sprite.new(117, h_high, "□"),
  Sprite.new(122, h_high, "□"),
  Sprite.new(123, h_nomal, "□"),
  Sprite.new(124, h_nomal, "□"),
  Sprite.new(125, h_high, "□"),
  Sprite.new(161, h_nomal, "□"),
  Sprite.new(162, h_nomal, "□"),
  Sprite.new(164, h_nomal, "□")
]
8.times do |x|
  $block << Sprite.new(75 + x, h_high, "□")
end
# ハテナブロック
$hatena = [
  Hatena.new(18, h_nomal, "？", "coin"),
  Hatena.new(23, h_nomal, "？", "mushroom"),
  Hatena.new(24, h_high, "？", "coin"),
  Hatena.new(25, h_nomal, "？", "coin"),
  Hatena.new(59, h_nomal, "  ", "mushroom"),#隠れキノコ
  Hatena.new(73, h_nomal, "？", "coin"),
  Hatena.new(89, h_high, "？", "coin"),
  Hatena.new(95, h_nomal, "□", "star"),# 隠れスター
  Hatena.new(100, h_nomal, "？", "coin"),
  Hatena.new(103, h_nomal, "？", "coin"),
  Hatena.new(103, h_high, "？", "mushroom"),
  Hatena.new(106, h_nomal, "？", "coin"),
  Hatena.new(123, h_high, "？", "coin"),
  Hatena.new(124, h_high, "？", "coin"),
  Hatena.new(163, h_nomal, "？", "coin")
]
# 土管
$dokan = [
  Sprite.new(30, map.height - 3, ["|==|", " || "]),
  Sprite.new(38, map.height - 4, ["|==|", " || ", " || "]),
  Sprite.new(44, map.height - 5, ["|==|", " || ", " || ", " || "]),
  Sprite.new(52, map.height - 5, ["|==|", " || ", " || ", " || "]),
  Sprite.new(155, map.height - 3, ["|==|", " || "]),
  Sprite.new(172, map.height - 3, ["|==|", " || "])
]
# 階段
2.times do |i|
  pos = 127 if i == 0
  pos = 141 if i == 1
  4.times do |x|
    (x+1).times do |y|
      $wall << Sprite.new(pos + x, h_ground - y, "■")
    end
  end
end
4.times do |y|
  $wall << Sprite.new(145, h_ground - y, "■")
end
# 階段(下り)
2.times do |i|
  pos = 133 if i == 0
  pos = 148 if i == 1
  4.times do |x|
    y = 4
    (y - x).times do
      $wall << Sprite.new(pos + x, map.height - 6 + y, "■")
      y -= 1
    end
  end
end
# 最後の階段
6.times do |x|
  (x + 1).times do |y|
    $wall << Sprite.new(174 + x, h_ground - y, "■")
  end
end
6.times do |y|
  $wall << Sprite.new(180, h_ground - y, "■")
end
# 旗
flag = []
7.times do |i|
  flag << Sprite.new(map.width - 2, map.height - 3 - i, "| ")
end
flag << Sprite.new(map.width - 2, h_high, "▶ ")
$wall << Sprite.new(map.width - 2, h_ground, "■")

# --- Var ---
flg = 0
$pos_flg = 0
$score = 0
$coin = 0
$time = 400
count = 0

# render_drawで使う
ren_width = 17
ren_center = ren_width / 2
ren_height = 14

# main loop
loop do
  Key.update
  # --------

  system("cls")
  break if Key.down?(Key::ESCAPE)
  count += 1
  $time -= 1 if (count % 10) == 0
  # 移動
  mario.x += 1 if Key.down?("d") && !mario.touch_right($wall) && !mario.touch_right($dokan)&& !mario.touch_right($block) && !mario.touch_right($hatena)
  mario.x -= 1 if Key.down?("a") && !mario.touch_left($wall) && !mario.touch_left($dokan) && !mario.touch_left($block) && !mario.touch_left($hatena)

  mario.x = 0 if mario.x < 0
  mario.x = (map.width - 1) if mario.x >= map.width

  # enemy
  if mario.x > 66 && $pos_flg == 0
    $enemies << Enemy.new(76, h_high - 1, "▲")
    $enemies << Enemy.new(80, h_high - 1, "▲")
    $pos_flg = 1
  elsif mario.x > 89 && $pos_flg == 1
    $enemies << Enemy.new(105, h_ground - 1, "▲")
    $enemies << Enemy.new(109, h_ground - 1, "▲")
    $enemies << Enemy.new(110, h_ground - 1, "▲")
    $pos_flg = 2
  elsif mario.x > 107 && $pos_flg == 2
    $enemies << Enemy.new(121, h_ground - 1, "▲")
    $enemies << Enemy.new(122, h_ground - 1, "▲")
    $enemies << Enemy.new(125, h_ground - 1, "▲")
    $enemies << Enemy.new(126, h_ground - 1, "▲")
    $pos_flg = 3
  elsif mario.x > 152 && $pos_flg == 3
    $enemies << Enemy.new(170, h_ground - 1, "▲")
    $enemies << Enemy.new(171, h_ground - 1, "▲")
    $pos_flg = 4
  end

  Enemy.update($enemies) if (count % 3) == 0
  $enemies.length.times do |i|
    $enemies[i].y += 1 unless $enemies[i].touch_foot($wall) || $enemies[i].touch_foot($block) || $enemies[i].touch_foot($hatena) || $enemies[i].touch_foot($dokan)
    $enemies[i].vanish if $enemies[i].y > map.height
  end
  Sprite.clean($enemies)

  # mario
  mario.update
  Mushroom.update($mushroom) if (count % 2) == 0

  # draw msg
  if mario === flag
    puts "============="
    puts " GAME CLEAR!"
    puts "============="
    flg = 1
  end

  if mario.y > h_ground
    puts "============"
    puts " GAME OVER!"
    puts "============"
    mario.text = "×"
    flg = 1
  end

  if $time < 0
    puts "=========="
    puts " TIME UP!"
    puts "=========="
  end

  # draw data
  print "   MARIO            WORLD  TIME\n   "
  (6 - $score.to_s.length).times do
    print "0"
  end
  print "#{$score}  ◎×"
  if $coin.to_s.length == 1
    print "0"
  end
  print "#{$coin}    1-1    "
  (3 - $time.to_s.length).times do
    print "0"
  end
  puts "#{$time}"

  # draw render map
  draw = [mario, $enemies, $block, $hatena, $mushroom, flag, $dokan, $wall]
  if mario.x < ren_center
    map.render_draw(0, map.height - ren_height, ren_width, ren_height, draw)
  elsif mario.x > map.width - 1 - ren_center
    map.render_draw(map.width - ren_width, map.height - ren_height, ren_width, ren_height, draw)
  else
    map.render_draw(mario.x - ren_center, map.height - ren_height, ren_width, ren_height, draw)
  end

  puts "x: #{mario.x}, y: #{mario.y} "

  break if flg == 1 || mario.state == -1
end
