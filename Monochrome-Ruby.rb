require 'Win32API'

class Map
  def initialize(map: [[]], text_hash: {0 => "  "}, width: map[0].length, height: map.length, default_text: -1)
    @map = map
    @text_hash = text_hash
    if default_text == -1
      @default_text = text_hash.first[1]
    else
      @default_text = default_text
    end
    @map.length.times do |y|
      @map[0].length.times do |x|
        unless @text_hash.include?(@map[y][x]) || @map[y][x] == -1
          raise ArgumentError.new("i dont know text_hash => #{@map[y][x]}")
        end
      end
    end
    @width = width
    @height = height
    if @width < @map[0].length
      raise ArgumentError.new("Need map#width(#{@width}) >= map length(#{@map[0].length})")
    elsif @width > @map[0].length
      need = @width - @map[0].length
      @map.length.times do |i|
        need.times do
          @map[i] << -1 # default_text
        end
      end
    end

    if @height < @map.length
      raise ArgumentError.new("Need map#height(#{@height}) >= map length(#{@map.length})")
    elsif @height > @map.length
      need = @height - @map.length
      need.times do |i|
        x_ary = []
        @width.times do
          x_ary << -1 #Map.default_text
        end
        @map << x_ary
      end
    end
  end

  def draw(drawing = [])
    @height.times do |y|
      x = 0
      @width.times do # x
        drawed = 0
        drawing.length.times do |i|
          if drawing[i].class == Array
            sprites = drawing[i]
          else
            sprites = [drawing[i]]
          end
          sprites.length.times do |j|
            if (x == sprites[j].x && sprites[j].vanished? == false && 
              sprites[j].y <= y && y <= sprites[j].y + sprites[j].height - 1)
              print sprites[j].text[y - sprites[j].y]
              drawed = 1
              x += (sprites[j].width(y - sprites[j].y) - 1)
              break
            end
          end
          break if drawed == 1
        end
        if drawed == 0
          if @map[y][x] == -1
            print @default_text
          else
            print @text_hash[@map[y][x]]
          end
        end
        x += 1
      end
      puts ""
    end
  end

  def render_draw(ox, oy, width, height, drawing = [])
    y = (oy + self.height) % self.height
    height.times do # y
      break if y >= self.height
      x = (ox + self.width) % self.width
      width.times do # x
        drawed = 0
        break if x >= self.width
        drawing.length.times do |i|
          if drawing[i].class == Array
            sprites = drawing[i]
          else
            sprites = [drawing[i]]
          end
          sprites.length.times do |j|
            if (x == sprites[j].x && sprites[j].vanished? == false && 
              sprites[j].y <= y && y <= sprites[j].y + sprites[j].height - 1)
              print sprites[j].text[y - sprites[j].y]
              drawed = 1
              x += (sprites[j].width(y - sprites[j].y) - 1)
              break
            end
          end
          break if drawed == 1
        end
        if drawed == 0
          if @map[y][x] == -1
            print @default_text
          else
            print @text_hash[@map[y][x]]
          end
        end
        x += 1
      end
      y += 1
      puts ""
    end
  end

  def text=(ary)
    if (ary.length != 2) || (ary[0].class != Fixnum) || (ary[1].class != String)
      raise ArgumentError.new("Map#text= [hash_num, new_text]")
    end
    @text_hash[ary[0]] = ary[1]
  end

  def map
    return @map
  end

  def text_hash
    return @text_hash
  end

  def default_text
    return @default_text
  end

  def default_text=(str)
    @default_text = str
  end

  def width
    return @width
  end

  def height
    return @height
  end
end

class Sprite
  def initialize(x, y, text)
    @x = x
    @y = y
    if text == ""
      raise ArgumentError.new("Sprite#text Cannot use ''")
    elsif text.class == Array
      @text = text
      @height = @text.length
    else
      @text = [text]
      @height = 1
    end
    @max_width = 0
    @height.times do |i|
      @width = 0
      @text[i].scan(/./) do |j|
        if /[ぁ-んー－]/ =~ j# 全角ひらがな
          @width += 1
        elsif /\A[ｧ-ﾝﾞﾟ]+\z/ =~ j# 半角型カタカナ
          @width += 0.5
        elsif /[ -~。-゜]/ =~ j# 半角
          @width += 0.5
        else
          @width += 1
        end
      end
      @max_width = @width.round if @max_width <= @width
    end
    @is_vanish = false
  end
  
  def hit(sprites, x: 0, y: 0)
    my_x = self.x + x
    my_y = self.y + y
    my_wid = self.x + x + self.width - 1
    my_hei = self.y + y + self.height - 1

    if sprites.class == Array
      sprites_ary = sprites
    else
      sprites_ary = [sprites]
    end
    sprites_ary.length.times do |i|
      next if sprites_ary[i].vanished?
      sp_x = sprites_ary[i].x
      sp_y = sprites_ary[i].y
      sp_wid = sp_x + sprites_ary[i].width - 1
      sp_hei = sp_y + sprites_ary[i].height - 1
      # judge
      if ( my_x <= sp_wid && my_y <= sp_hei && my_wid >= sp_x && my_hei >= sp_y)
        return true
      end
    end
    return false
  end

  def ===(sprites_ary)
    return hit(sprites_ary)
  end

  def check(sprites, x: 0, y: 0)
    my_x = self.x + x
    my_y = self.y + y
    my_wid = self.x + x + self.width - 1
    my_hei = self.y + y + self.height - 1

    if sprites.class == Array
      sprites_ary = sprites
    else
      sprites_ary = [sprites]
    end
    return_ary = []
    sprites_ary.length.times do |i|
      next if sprites_ary[i].vanished?
      sp_x = sprites_ary[i].x
      sp_y = sprites_ary[i].y
      sp_wid = sp_x + sprites_ary[i].width - 1
      sp_hei = sp_y + sprites_ary[i].height - 1
      # judge
      if ( my_x <= sp_wid && my_y <= sp_hei && my_wid >= sp_x && my_hei >= sp_y)
        return_ary << sprites_ary[i]
      end
    end
    return return_ary
  end

  def touch(sprites_ary)
    if (hit(sprites_ary, y: -1) || hit(sprites_ary, y: 1) || 
      hit(sprites_ary, x: 1) || hit(sprites_ary, x: -1))
      return true
    else
      return false
    end
  end

  def touch_head(sprites_ary)
    return hit(sprites_ary, y: -1)
  end
  
  def touch_foot(sprites_ary)
    return hit(sprites_ary, y: 1)
  end

  def touch_right(sprites_ary)
    return hit(sprites_ary, x: 1)
  end

  def touch_left(sprites_ary)
    return hit(sprites_ary, x: -1)
  end

  def vanish
    @is_vanish = true
  end

  def vanished?
    return @is_vanish
  end

  def self.clean(sprites_ary)
    sprites_ary.length.times do |i|
      check = (sprites_ary.length - 1 - i)
      if sprites_ary[check].vanished?
        sprites_ary.delete_at(check)
      end
    end        
  end

  def x
    return @x
  end

  def x=(val)
    @x = val
  end

  def y
    return @y
  end

  def y=(val)
    @y = val
  end

  def text
    return @text
  end

  def text=(str)
    if str == ""
      raise ArgumentError.new("Sprite#text Cannot use ''")
    elsif str.class == Array
      @text = str
      @height = @text.length
    else
      @text = [str]
      @height = 1
    end
    @max_width = 0
    @height.times do |i|
      @width = 0
      @text[i].scan(/./) do |j|
        if /[ぁ-んー－]/ =~ j# 全角ひらがな
          @width += 1
        elsif /\A[ｧ-ﾝﾞﾟ]+\z/ =~ j# 半角型カタカナ
          @width += 0.5
        elsif /[ -~。-゜]/ =~ j# 半角
          @width += 0.5
        else
          @width += 1
        end
      end
      @max_width = @width.round if @max_width <= @width
    end
  end

  def width(height = -1)
    if height == -1
      return @max_width
    elsif height > @text.length
      raise ArgumentError.new("Sprite#width(height: #{height})over Sprite#height")
    else
      @width = 0
      @text[height].scan(/./) do |i|
        if /[ぁ-んー－]/ =~ i# 全角ひらがな
          @width += 1
        elsif /\A[ｧ-ﾝﾞﾟ]+\z/ =~ i# 半角型カタカナ
          @width += 0.5
        elsif /[ -~。-゜]/ =~ i# 半角
          @width += 0.5
        else
          @width += 1
        end
      end
      return @width.round
    end
  end

  def height
    return @text.length
  end
end


class Key
  ESCAPE = 0x1b
  RETURN = 0x0d
  UP = 0x48
  DOWN = 0x50
  RIGHT = 0x4d
  LEFT = 0x4b
  SPACE = " "

  def initialize
    @@kbhit = Win32API.new('msvcrt','_kbhit',[],'l')
    @@getch = Win32API.new('msvcrt','_getch',[],'l')
    @@pressed = false
  end

  class << self 
    def kbhit()
      if @@kbhit.call != 0
        return true
      else 
        return false
      end
    end
    
    def getch()
      return @@getch.call
    end

    def update()
      if kbhit()
        @@key = getch()
        @@pressed = true
      else
        @@pressed = false
      end
    end

    def down?(key_code)
      if @@pressed == true
        @@key = @@key.chr if key_code.class == String

        if @@key == key_code
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end
end

Key.new()
