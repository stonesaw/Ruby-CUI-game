#ruby -Ku
require "matrix"
require_relative './../Monochrome-Ruby'

# 参考: https://qiita.com/akicho8/items/8bef95520452c052c581
# 一部変更: 直接描画 => 配列に保存

# ===== 参考 ======
V = Vector

class App
  def initialize(w, h)
    @w = w
    @h = h
    @m = {}
    @ary = []
    @h.times do |y|
      x_ary = []
      @w.times do |x|
        @m[V[x, y]] = true
        x_ary << 0
      end
      @ary << x_ary
    end
  end

  def run(v)
    @m[v] = false
    around.shuffle.each do |a|
      v1 = v + a
      v2 = v1 + a
      if @m[v2]
        @m[v1] = false
        run(v2)
      end
    end
  end

  def ary_create
    @h.times do |y|
      @w.times do |x|
        v = V[x, y]
        case
        when @m[v]
          @ary[y][x] = 1
        when v == V[1, 1]
          @ary[y][x] = 2
        when v == V[@w - 2, @h - 2]
          @ary[y][x] = 3
        else
          @ary[y][x] = 0
        end
      end
    end
  end

  def around
    @around ||= [[0, -1], [-1,  0], [1,  0],[0,  1]].collect { |e| V[*e] }
  end

  def ary
    return @ary
  end

  def width
    @w
  end

  def height
    @h
  end
end

app = App.new(31, 23)
app.run(V[1, 1])
app.ary_create
# ===== 参考 =====

map = Map.new(map: app.ary, text_hash: {0 => "  ", 1 => "■", 2 => "ｓ", 3 => "ｇ"})

x = 0
y = 0
ren_width = 10
ren_height = 10

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)
  x += 1 if Key.down?(Key::RIGHT)
  x -= 1 if Key.down?(Key::LEFT)
  y += 1 if Key.down?(Key::DOWN)
  y -= 1 if Key.down?(Key::UP)

  x = 0 if x < 0
  x = map.width - ren_width if x > map.width - ren_width
  y = 0 if y < 0
  y = map.height - ren_height if y > map.height - ren_height

  puts "Map#render_draw sample"
  puts "方向キーでマップの視点を動かせます。"
  puts ""
  
  map.render_draw(x, y, ren_width, ren_height)

  puts ""
  puts "--- data ---"
  app.height.times do |y|
    p app.ary[y]
  end
end