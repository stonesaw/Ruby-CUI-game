require 'Win32API'

class Map
  attr_reader :map, :text_hash, :width, :height
  attr_accessor :default_text

  def initialize(map: [[]], text_hash: {0 => "  "}, width: map[0].length, height: map.length, default_text: -1)
    @map = map
    @text_hash = text_hash
    if default_text == -1
      @default_text = text_hash.first[1]
    else
      @default_text = default_text
    end
    @map.length.times do |y|
      @map[y].length.times do |x|
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
    self.height.times do |y|
      x = 0
      self.width.times do # x
        drawed = 0
        drawing.each do |dr|
          if dr.class == Array
            sprites = dr
          else
            sprites = [dr]
          end
          sprites.each do |sp|
            break if x >= self.width
            if (x == sp.x && sp.vanished? == false && sp.y <= y && y <= sp.y + sp.height - 1)
              print sp.text[y - sp.y]
              drawed = 1
              x += (sp.width(y - sp.y) - 1)
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
    puts "off map!" if ox < 0 || oy < 0
    y = (oy + self.height) % self.height
    height.times do # y
      break if y >= self.height || y - oy >= height
      x = (ox + self.width) % self.width
      width.times do # x
        drawed = 0
        break if x >= self.width || x - ox >= width
        drawing.each do |dr|
          if dr.class == Array
            sprites = dr
          else
            sprites = [dr]
          end
          sprites.each do |sp|
            break if x - ox >= width
            if (x == sp.x && sp.vanished? == false && sp.y <= y && y <= sp.y + sp.height - 1)              
              print sp.text[y - sp.y]
              drawed = 1
              x += (sp.width(y - sp.y) - 1)
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
    raise ArgumentError.new("Map#text= [hash_num, new_text]") if (ary.length != 2) || !(ary[0].class == Integer || ary[0].class == Symbol) || (ary[1].class != String)
    raise ArgumentError.new("Map#text=() text_hash undefined => #{ary[0]}") unless text_hash.has_key?(ary[0])
    @text_hash[ary[0]] = ary[1]
  end
end

class Sprite
  attr_accessor :x, :y

  def initialize(x, y, text)
    raise ArgumentError.new("Sprite#x (#{x}) plz Integer") unless x.class == Integer
    raise ArgumentError.new("Sprite#y (#{y}) plz Integer") unless y.class == Integer
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
      @width = text_check(@text[i])
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
    sprites_ary.each do |sp|
      next if sp.vanished?
      sp_wid = sp.x + sp.width - 1
      sp_hei = sp.y + sp.height - 1
      # judge
      if my_x <= sp_wid && my_y <= sp_hei && my_wid >= sp.x && my_hei >= sp.y
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
    sprites_ary.each do |sp|
      next if sp.vanished?
      sp_wid = sp.x + sp.width - 1
      sp_hei = sp.y + sp.height - 1
      # judge
      if my_x <= sp_wid && my_y <= sp_hei && my_wid >= sp.x && my_hei >= sp.y
        return_ary << sp
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

  def text
    return @text
  end

  def text=(str)
    if str == ""
      raise ArgumentError.new("Sprite#text= Cannot use ''")
    elsif str.class == Array
      @text = str
      @height = @text.length
    else
      @text = [str]
      @height = 1
    end
    @max_width = 0
    @height.times do |i|
      @width = text_check(@text[i])
      @max_width = @width.round if @max_width <= @width
    end
  end

  def width(height = -1)
    if height == -1
      return @max_width
    elsif height > @text.length
      raise ArgumentError.new("Sprite#width(height: #{height})over Sprite#height")
    else
      @width = text_check(@text[height])
      return @width
    end
  end

  def height
    return @height
  end

  private
  def text_check(text)
    width = 0
    text.scan(/./) do |i|
      if /\A[ぁ-んー－]+\z/ =~ i# 全角ひらがな
        width += 1
      elsif /\A[ｧ-ﾝﾞﾟ]+\z/ =~ i# 半角型カタカナ
        width += 0.5
      elsif /\A[ -~。-゜]+\z/ =~ i# 半角
        width += 0.5
      else
        width += 1
      end
    end
    return width.round
  end
end

class Key
  ESCAPE = 0x1b
  RETURN = 0x0d
  BACKSPACE = 0x08
  DELETE = 0x53
  TAB = 0x09
  UP = 0x48
  DOWN = 0x50
  RIGHT = 0x4d
  LEFT = 0x4b
  SPACE = " "
  HOME = 0x47
  K_END = 0x4f
  PAGEUP = 0x49
  PAGEDOWN = 0x51
  INSERT = 0x52
  F1 = 0x3b
  F2 = 0x3c
  F3 = 0x3d
  F4 = 0x3e
  F5 = 0x3f
  F6 = 0x40
  F7 = 0x41
  F8 = 0x42
  F9 = 0x43
  F10 = 0x44
  F11 = 0x45
  F12 = 0x46
  ANY = :any_key

  def initialize
    @@kbhit = Win32API.new('msvcrt','_kbhit',[],'l')
    @@getch = Win32API.new('msvcrt','_getch',[],'l')
    @@pressed = false
  end

  class << self
    # You have to write this to use keyboard!
    def update()
      if kbhit()
        @@key = getch()
        @@pressed = true
      else
        @@pressed = false
      end
    end

    # return Boolean  
    # key_code "a-z", Key::(key_code)
    # *plz show Key-Reference(https://github.com/stonesaw/Ruby-CUI-game#key)*
    def down?(key_code)
      if @@pressed == true
        return true if key_code == ANY
        if key_code.class == String
          return @@key.chr == key_code ? true : false
        else
          return @@key == key_code ? true : false
        end
      else
        return false
      end
    end

    private
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
  end
end

Key.new()
