# ---- 各キャラクター・アイテム用のクラス ----
class Me < Sprite
  attr_accessor :state, :tick

  def initialize(x, y, text, state = 0)
    super(x, y, text)
    @state = state
    # state 0 => マリオ(小さい状態)
    # state 1 => スーパーマリオ
    # state +10 => スター(無敵状態)
    @jump = 0
    @tick = 0
    # スターの時間制限用
  end

  def update
    # 移動
    # 右にオブジェクトがあるときは無効
    self.x += 1 if Key.down?("d") && !self.touch_right(Play.wall) && !self.touch_right(Play.dokan)&& !self.touch_right(Play.block) && !self.touch_right(Play.hatena)
    # 左にオブジェクトがあるときは無効
    self.x -= 1 if Key.down?("a") && !self.touch_left(Play.wall) && !self.touch_left(Play.dokan) && !self.touch_left(Play.block) && !self.touch_left(Play.hatena)
    
    # マップから出ないようにする
    self.x = 0 if self.x < 0
    self.x = (Play.map.width - 1) if self.x >= Play.map.width

    # 地面に触れているか
    if self.touch_foot(Play.wall) || self.touch_foot(Play.block) || self.touch_foot(Play.hatena) || self.touch_foot(Play.dokan)
      @jump = 1 if Key.down?(Key::SPACE)
    else
      # 重力
      self.y += 1
    end

    # ジャンプ
    if 0 < @jump && @jump < 3
      self.y -= 3
      @jump += 1
    elsif @jump == 3
      self.y -= 2
      @jump = 0
    end

    # ブロックをたたく(ジャンプしている・上昇しているときのみ)
    if @jump > 0 && (self.touch_head(Play.block) || self === Play.block)
      @jump = 0 # ジャンプのフラグを下ろす
      if self.state >= 1 # 小さい状態のときはたたけない
        # 当たっているブロックを配列に入れる
        # nilが返ってきた場合は.compactによって、nilを削除する
        col = [
          self.check(Play.block, y: -1).first,
          # self.check(Play.block, y: -2).first,
          self.check(Play.block).first
        ].compact.first

        # 当たっているブロックがあれば削除する
        unless col == nil
          # ブロックに敵が乗っていたら削除
          ene_col = [
            col.check(Play.enemies).first,
            col.check(Play.enemies, y: -1).first
          ].compact.first
          unless ene_col == nil
            ene_col.vanish
            Sprite.clean(Play.enemies)
            $score += 100
          end

          # ブロックを削除
          col.vanish
          Sprite.clean(Play.block)
        end
        # 当たっているとき、座標が被ってしまうことがあるため、yをプラス1
        self.y += 1
      end
    end

    # ハテナブロックをたたく
    col = [
      self.check(Play.hatena, y: -1).first,
      self.check(Play.hatena).first
    ].compact.first
    if @jump > 0 && col != nil
      @jump = 0
      # ハテナブロックがまだたたかれていない場合
      if col.text[0] == "？" || col.text[0] == "  " || col.text[0] == "□"
        # ハテナブロックのテキストを獲得済みの状態に
        col.text[0] = "■"
        if col.item == "coin" # アイテムがコイン
          $coin += 1
          $score += 200
        elsif col.item == "mushroom" #アイテムがキノコ
          Play.mushroom << Mushroom.new(col.x, col.y - 2)
        elsif col.item == "star" # アイテムがスター
          Play.star << Star.new(col.x, col.y - 2)
        end
        # ブロックに敵が乗っていたら削除
        ene_col = [
          col.check(Play.enemies).first,
          col.check(Play.enemies, y: -1).first
        ].compact.first
        unless ene_col == nil
          ene_col.vanish
          Sprite.clean(Play.enemies)
          $score += 100
        end
      else# ハテナブロックが既にたたかれていた場合
        self.y += 1
      end
      # y座標を調整
      self.y += 1 if (self.state % 10) == 1
      self.y -= 1 if self.y < Play.h_nomal
    end

    # キノコを取る
    if (self === Play.mushroom || self.touch(Play.mushroom)) && !(self === Play.block || self === Play.hatena)
      col = [
        self.check(Play.mushroom).first,
        self.check(Play.mushroom, x: 1).first,
        self.check(Play.mushroom, x: -1).first,
        self.check(Play.mushroom, y: 1).first,
        self.check(Play.mushroom, y: -1).first
      ].compact
      unless col == nil
        # 取ったキノコを消す
        col.first.vanish
        Sprite.clean(Play.mushroom)
        # マリオの状態を変更
        if (self.state % 10) == 0
          self.state += 1
          self.y -= 1
        end
        $score += 1000
      end
    end

    # スターを取る
    if (self === Play.star || self.touch(Play.star)) && !(self === Play.block || self === Play.hatena)
      col = [
        self.check(Play.star).first,
        self.check(Play.star, x: 1).first,
        self.check(Play.star, x: -1).first,
        self.check(Play.star, y: 1).first,
        self.check(Play.star, y: -1).first
      ].compact
      unless col == nil
        # 取ったスターを消す
        col.first.vanish
        Sprite.clean(Play.star)
        # マリオの状態を変更
        self.state += 10 if self.state < 10
        $score += 1000
        self.tick = Play.count
      end
    end

    # スターの時間制限
    if self.state >= 10 && (Play.count - self.tick) > 80
       self.state -= 10
    end

    # 状態によって描画されるテキストを変更
    self.text = ["ｃ"] if self.state == 0# マリオ(小さい状態)
    self.text = ["ｃ", "人"] if self.state == 1# スーパーマリオ
    self.text = ["☆"] if self.state == 10# スター(無敵)
    self.text = ["☆", "人"] if self.state == 11# スター(無敵)

    # 敵を踏む
    if self.touch_foot(Play.enemies)
      col = self.check(Play.enemies, y: 1).first
      unless col == nil
        col.vanish
        $score += 100
        self.y -= 2
      end
      Sprite.clean(Play.enemies)
    end

    # 敵との衝突
    if self === Play.enemies || self.touch_right(Play.enemies) || self.touch_left(Play.enemies)
      # 小さい状態の時
      if self.state == 0
        self.text = "×"
        self.state = -1
      elsif self.state >= 10# スター状態の時
        # 衝突した敵を削除する
        col = [
          self.check(Play.enemies).first,
          self.check(Play.enemies, x: 1).first,
          self.check(Play.enemies, x: -1).first,
          self.check(Play.enemies, y: 1).first,
          self.check(Play.enemies, y: -1).first
        ].compact
        unless col == nil
          col.first.vanish
          Sprite.clean(Play.enemies)
        end
        # スコアを加算
        $score += 100
      else
        self.state -= 1
        col = [
          self.check(Play.enemies).first,
          self.check(Play.enemies, x: 1).first,
          self.check(Play.enemies, x: -1).first
        ].compact
        unless col == nil
          col.first.vanish
          Sprite.clean(Play.enemies)
        end
      end
    end
  end
end

# class 敵
class Enemy < Sprite
  attr_accessor :dx

  def initialize(x, y, text, dx = -1)
    super(x, y, text)
    @dx = dx
  end

  def self.update(sprite)
    sprite.length.times do |i|
      # 向きを変える
      sprite[i].dx = -1 if sprite[i].touch_right(Play.block) || sprite[i].touch_right(Play.hatena) || sprite[i].touch_right(Play.dokan)
      sprite[i].dx = 1 if sprite[i].touch_left(Play.block) || sprite[i].touch_left(Play.hatena) || sprite[i].touch_left(Play.dokan)
      # 移動
      if sprite[i].x >= 0
        if sprite[i].touch_foot(Play.wall) || sprite[i].touch_foot(Play.block) || sprite[i].touch_foot(Play.hatena) || sprite[i].touch_foot(Play.dokan)
          sprite[i].x += sprite[i].dx
        end
      end
    end
  end
end

# class ハテナブロック
class Hatena < Sprite
  attr_reader :item

  def initialize(x, y, text, item)# item => str
    super(x, y, text)
    @item = item
  end
end

# class キノコ
class Mushroom < Sprite
  attr_accessor :dx

  def initialize(x, y, text = "茸", dx = 1)
    super(x, y, text)
    @dx = dx
  end

  def self.update(sprite)
    sprite.length.times do |i|
      # 向きを変える
      sprite[i].dx = -1 if sprite[i].touch_right(Play.block) || sprite[i].touch_right(Play.hatena) || sprite[i].touch_right(Play.dokan)
      sprite[i].dx = 1 if sprite[i].touch_left(Play.block) || sprite[i].touch_left(Play.hatena) || sprite[i].touch_left(Play.dokan)
      # 移動
      if sprite[i].touch_foot(Play.wall) || sprite[i].touch_foot(Play.block) || sprite[i].touch_foot(Play.hatena) || sprite[i].touch_foot(Play.dokan)
        sprite[i].x += sprite[i].dx
      else
        sprite[i].y += 1
      end
    end
  end
end

# class スター
class Star < Sprite
  attr_accessor :dx

  def initialize(x, y, text = "★", dx = 1)
    super(x, y, text)
    @dx = dx
  end

  def self.update(sprite)
    sprite.each do |sp|
      # 向きを変える
      sp.dx = -1 if sp.touch_right(Play.block) || sp.touch_right(Play.hatena) || sp.touch_right(Play.dokan)
      sp.dx = 1 if sp.touch_left(Play.block) || sp.touch_left(Play.hatena) || sp.touch_left(Play.dokan)
      # 移動
      if sp.touch_foot(Play.wall) || sp.touch_foot(Play.block) || sp.touch_foot(Play.hatena) || sp.touch_foot(Play.dokan)
        sp.x += sp.dx
      else
        sp.y += 1
      end
    end
  end
end
# ---- ----


# シーン - プレイ
class Play
  def initialize
    # 2次元配列[height][width] を作成
    @@map = Map.new(width: 190, height: 20)
    # 高さ
    @@h_ground = @@map.height - 2# 地面の高さ
    @@h_nomal = @@map.height - 5# ブロックの基本の高さ
    @@h_high = @@map.height - 10# 高いブロックの高さ
    
    # マリオ
    @@mario = Me.new(4, @@h_ground, "ｃ")
    # アイテム
    @@mushroom = []
    @@star = []
    # 敵(クリボー)
    @@enemies = [
      Enemy.new(29, @@h_ground, "▲"),
      Enemy.new(42, @@h_ground, "▲"),
      Enemy.new(49, @@h_ground, "▲"),
      Enemy.new(50, @@h_ground, "▲")
    ]
    
    # ブロック生成
    Play.create_block()

    # --- Var ---
    $score = 0
    $coin = 0
    $time = 400
    @@flg = 0
    @@pos_flg = 0
    @@count = 0
  end

  class << self
    def update
      # エスケープキーが押されたら、Menuシーンへ
      Scene.next(init: true) if Key.down?(Key::ESCAPE)

      # time
      @@count += 1
      $time -= 1 if (@@count % 4) == 0

      # マリオ
      @@mario.update

      # キノコ(2フレームに一度更新)
      Mushroom.update(@@mushroom) if (@@count % 2) == 0
      # スター(2フレームに一度更新)
      Star.update(@@star) if (@@count % 2) == 0

      # マリオの位置によるフラグ(敵の出現)
      if @@mario.x > 65 && @@pos_flg == 0
        @@enemies << Enemy.new(76, @@h_high - 1, "▲")
        @@enemies << Enemy.new(80, @@h_high - 1, "▲")
        @@pos_flg = 1
      elsif @@mario.x > 89 && @@pos_flg == 1
        @@enemies << Enemy.new(105, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(109, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(110, @@h_ground - 1, "▲")
        @@pos_flg = 2
      elsif @@mario.x > 107 && @@pos_flg == 2
        @@enemies << Enemy.new(121, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(122, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(125, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(126, @@h_ground - 1, "▲")
        @@pos_flg = 3
      elsif @@mario.x > 152 && @@pos_flg == 3
        @@enemies << Enemy.new(170, @@h_ground - 1, "▲")
        @@enemies << Enemy.new(171, @@h_ground - 1, "▲")
        @@pos_flg = 4
      end
    
      # 敵の移動(3フレーム毎)
      Enemy.update(@@enemies) if (@@count % 3) == 0
      # 敵の落下(毎フレーム)
      @@enemies.length.times do |i|
        @@enemies[i].y += 1 unless @@enemies[i].touch_foot(@@wall) || @@enemies[i].touch_foot(@@block) || @@enemies[i].touch_foot(@@hatena) || @@enemies[i].touch_foot(@@dokan)
        @@enemies[i].vanish if @@enemies[i].y > @@map.height
      end
      Sprite.clean(@@enemies)
    end

    def draw
      # --- draw msg ---
      # フラグ - ゲームクリア
      @@flg = 2 if @@mario === @@flag
      
      # フラグ - ゲームオーバー
      if @@mario.y > @@h_ground
        @@mario.text = "×"
        @@flg = 1
      end
      
      # フラグ - タイムアップ
      if $time <= 0
        @@mario.text = "×"
        @@flg = 1
      end
      
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
      draw = [@@mario, @@enemies, @@block, @@hatena, @@mushroom, @@star, @@flag, @@dokan, @@wall]

      if @@mario.x < WIDTH / 2
        ox = 0
      elsif @@mario.x > @@map.width - 1 - WIDTH / 2
        ox = @@map.width - WIDTH
      else
        ox = @@mario.x - WIDTH / 2
      end
      @@map.render_draw(ox, @@map.height - HEIGHT, WIDTH, HEIGHT, draw)
      
      # フラグがゲームオーバーまたはタイムアップだった時
      if @@flg == 1 || @@mario.state == -1
        sleep(1)
        $life -= 1
        Scene.back(init: true)# Scene Lifeへ
      end
      Scene.select(5, init: true) if @@flg == 2
    end
  
    def map
      @@map
    end

    def mario
      @@mario
    end

    def enemies
      @@enemies
    end

    def block
      @@block
    end

    def wall
      @@wall
    end

    def hatena
      @@hatena
    end

    def dokan
      @@dokan
    end

    def flag
      @@flag
    end

    def mushroom
      @@mushroom
    end

    def star
      @@star
    end

    def h_nomal
      @@h_nomal
    end

    def count
      @@count
    end

    def create_block()
      # --- ブロック生成 ---
      # 地面
      @@wall = []
      @@map.width.times do |i|
        next if (i == 64 || i == 65)
        next if (81 <= i && i <= 83)
        next if (146 <= i && i <= 147)
        @@wall << Sprite.new(i, @@map.height - 1, "■")
      end
      # 壊せるブロック
      @@block = [
        Sprite.new(22, @@h_nomal, "□"),
        Sprite.new(24, @@h_nomal, "□"),
        Sprite.new(26, @@h_nomal, "□"),
        Sprite.new(72, @@h_nomal, "□"),
        Sprite.new(74, @@h_nomal, "□"),
        Sprite.new(86, @@h_high, "□"),
        Sprite.new(87, @@h_high, "□"),
        Sprite.new(88, @@h_high, "□"),
        Sprite.new(89, @@h_nomal, "□"),
        Sprite.new(94, @@h_nomal, "□"),
        Sprite.new(112, @@h_nomal, "□"),
        Sprite.new(115, @@h_high, "□"),
        Sprite.new(116, @@h_high, "□"),
        Sprite.new(117, @@h_high, "□"),
        Sprite.new(122, @@h_high, "□"),
        Sprite.new(123, @@h_nomal, "□"),
        Sprite.new(124, @@h_nomal, "□"),
        Sprite.new(125, @@h_high, "□"),
        Sprite.new(161, @@h_nomal, "□"),
        Sprite.new(162, @@h_nomal, "□"),
        Sprite.new(164, @@h_nomal, "□")
      ]
      8.times do |x|
        @@block << Sprite.new(75 + x, @@h_high, "□")
      end
      # ハテナブロック
      @@hatena = [
        Hatena.new(18, @@h_nomal, "？", "coin"),
        Hatena.new(23, @@h_nomal, "？", "mushroom"),
        Hatena.new(24, @@h_high, "？", "coin"),
        Hatena.new(25, @@h_nomal, "？", "coin"),
        Hatena.new(59, @@h_nomal, "  ", "mushroom"),#隠れキノコ
        Hatena.new(73, @@h_nomal, "？", "coin"),
        Hatena.new(89, @@h_high, "？", "coin"),
        Hatena.new(95, @@h_nomal, "□", "star"),# 隠れスター
        Hatena.new(100, @@h_nomal, "？", "coin"),
        Hatena.new(103, @@h_nomal, "？", "coin"),
        Hatena.new(103, @@h_high, "？", "mushroom"),
        Hatena.new(106, @@h_nomal, "？", "coin"),
        Hatena.new(123, @@h_high, "？", "coin"),
        Hatena.new(124, @@h_high, "？", "coin"),
        Hatena.new(163, @@h_nomal, "？", "coin")
      ]
      # 土管
      @@dokan = [
        Sprite.new(30, @@map.height - 3, ["|==|", " || "]),
        Sprite.new(38, @@map.height - 4, ["|==|", " || ", " || "]),
        Sprite.new(44, @@map.height - 5, ["|==|", " || ", " || ", " || "]),
        Sprite.new(52, @@map.height - 5, ["|==|", " || ", " || ", " || "]),
        Sprite.new(155, @@map.height - 3, ["|==|", " || "]),
        Sprite.new(172, @@map.height - 3, ["|==|", " || "])
      ]
      # 階段
      2.times do |i|
        pos = 127 if i == 0
        pos = 141 if i == 1
        4.times do |x|
          (x+1).times do |y|
            @@wall << Sprite.new(pos + x, @@h_ground - y, "■")
          end
        end
      end
      4.times do |y|
        @@wall << Sprite.new(145, @@h_ground - y, "■")
      end
      # 階段(下り)
      2.times do |i|
        pos = 133 if i == 0
        pos = 148 if i == 1
        4.times do |x|
          y = 4
          (y - x).times do
            @@wall << Sprite.new(pos + x, @@map.height - 6 + y, "■")
            y -= 1
          end
        end
      end
      # 最後の階段
      6.times do |x|
        (x + 1).times do |y|
          @@wall << Sprite.new(174 + x, @@h_ground - y, "■")
        end
      end
      6.times do |y|
        @@wall << Sprite.new(180, @@h_ground - y, "■")
      end
      # 旗
      @@flag = []
      7.times do |i|
        @@flag << Sprite.new(@@map.width - 2, @@map.height - 3 - i, "| ")
      end
      @@flag << Sprite.new(@@map.width - 2, @@h_high, "▶ ")
      @@wall << Sprite.new(@@map.width - 2, @@h_ground, "■")
    end
  end
end
