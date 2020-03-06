require 'Win32API'

class Sprite
    def initialize(x, y, text)
        @x = x
        @y = y
        if text == ""
            puts "ERROR: Sprite.text"
            puts "I dont know ''"
            exit
        else
            @text = text
        end
        @width = 0
        @text.scan(/./) do |i|
            if( /[ -~。-゜]/ =~ i)
                @width += 1  #半角
            else
                @width += 2  #全角
            end
        end
        # @height  #TO DO
        @is_vanish = false
    end

    def draw
        if @is_vanish == false
            Map.drawing << self
        end
    end

    def self.draw(sprites_ary)
        sprites_ary.length.times do |i|
            if sprites_ary[i].vanished? == false
                Map.drawing << sprites_ary[i]
            end
        end
    end
    
    def hit(sprites_ary)
        if sprites_ary.class == Array
            sprites_ary.length.times do |i|
                if self.x == sprites_ary[i].x && self.y == sprites_ary[i].y
                    if sprites_ary[i].vanished? == false
                        return true
                    end
                end
            end
            return false
        else
            if self.x == sprites_ary.x && self.y == sprites_ary.y
                return true
            else
                return false
            end
        end
    end

    def ===(sprites_ary)
        return hit(sprites_ary)
    end

    def check(sprites_ary)
        if sprites_ary.class == Array
            return_ary = []
            sprites_ary.length.times do |i|
                if self.x == sprites_ary[i].x && self.y == sprites_ary[i].y
                    if sprites_ary[i].vanished? == false
                        return_ary << sprites_ary[i]
                    end
                end
            end
            return return_ary
        else
            if self.x == sprites_ary.x && self.y == sprites_ary.y
                return [self]
            else
                return []
            end
        end
    end

    def touch_head(sprites_ary)
        if sprites_ary.class == Array
            sprites_ary.length.times do |i|
                if self.x == sprites_ary[i].x && self.y - 1 == sprites_ary[i].y
                    return true
                end
            end
            return false
        else
            if self.x == sprites_ary.x && self.y - 1 == sprites_ary.y
                return true
            else
                return false
            end
        end
    end
    
    def touch_foot(sprites_ary)
        if sprites_ary.class == Array
            sprites_ary.length.times do |i|
                if self.x == sprites_ary[i].x && self.y + 1 == sprites_ary[i].y
                    return true
                end
            end
            return false
        else
            if self.x == sprites_ary.x && self.y + 1 == sprites_ary.y
                return true
            else
                return false
            end
        end
    end

    def touch_right(sprites_ary)
        if sprites_ary.class == Array
            sprites_ary.length.times do |i|
                if self.x + 1 == sprites_ary[i].x && self.y == sprites_ary[i].y
                    return true
                end
            end
            return false
        else
            if self.x + 1 == sprites_ary.x && self.y == sprites_ary.y
                return true
            else
                return false
            end
        end
    end

    def touch_left(sprites_ary)
        if sprites_ary.class == Array
            sprites_ary.length.times do |i|
                if self.x - 1 == sprites_ary[i].x && self.y == sprites_ary[i].y
                    return true
                end
            end
            return false
        else
            if self.x - 1 == sprites_ary.x && self.y == sprites_ary.y
                return true
            else
                return false
            end
        end
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
        @text = str
    end

    def width
        return @width
    end

    # def height
    #     return @height
    # end

    def is_vanish
        return @is_vanish
    end
end

class Map
    def initialize(map: [[]], text_hash: {0 => "・"}, width: map[0].length, height: map.length)
        @@drawing = []
        @@map = map
        @@text_hash = text_hash
        @@default_text = @@text_hash.first[1]
        @@map.length.times do |y|
            @@map[0].length.times do |x|
                if !(@@text_hash.include?(@@map[y][x]) ||  @@map[y][x] == -1)
                    puts "ERROR : Map.new"
                    puts "i dont know map's num => #{@@map[y][x]}"
                    exit
                end
            end
        end
        @@width = width
        @@height = height
        if @@width < @@map[0].length
            puts "ERROR : Map.new"
            puts "map width(#{@@width}) less than map length(#{@@map[0].length})"
            exit
        elsif @@width > @@map[0].length
            need = @@width - @@map[0].length
            @@map.length.times do |i|
                need.times do
                    if @@text_hash.include?(0)
                        @@map[i] << 0
                    else
                        @@map[i] << -1 #Map.default_text
                    end
                end
            end
        end

        if @@height < @@map.length
            puts "ERROR : Map.new"
            puts "map height(#{@@height}) less than map length(#{@@map.length})"
            exit
        elsif @@height > @@map.length
            need = @@height - @@map.length
            need.times do |i|
                x_ary = []
                @@width.times do
                    if @@text_hash.include?(0)
                        x_ary << 0
                    else
                        x_ary << -1 #Map.default_text
                    end
                end
                @@map << x_ary
            end
        end
    end

    def self.draw
        @@map.length.times do |y|
            x = 0
            @@map[0].length.times do
                flg = 0
                @@drawing.length.times do |i|
                    if (x == @@drawing[i].x && y == @@drawing[i].y)
                        print @@drawing[i].text
                        flg = 1
                        x += (@@drawing[i].width / 2 - 1)
                        break
                    end
                end
                if flg == 0
                    if @@map[y][x] == -1
                        print Map.default_text
                    else
                        print @@text_hash[@@map[y][x]]
                    end
                end
                x += 1
            end
            puts ""
        end
    end
    
    def self.update
        @@drawing = []
        system("cls")
    end

    def self.text=(ary)
        if (ary.length != 2) || (ary[0].class != Fixnum) || (ary[1].class != String)
            puts "ERROR : Argument Error from Map#text="
            puts "Map.text = [hash_num, new_text]"
            exit
        end
        @@text_hash[ary[0]] = ary[1]
    end

    def self.default_text
        return @@default_text
    end

    def self.default_text=(str)
        @@default_text = str
    end

    def self.drawing
        return @@drawing
    end

    def self.width
        return @@width
    end

    def self.height
        return @@height
    end
end

class Key
    ESCAPE = 27
    RETURN = 13

    def initialize
        @@kbhit = Win32API.new('msvcrt','_kbhit',[],'l')
        @@getch = Win32API.new('msvcrt','_getch',[],'l')
        @@pressed = false
    end

    class << self 
        def _kbhit()
            if @@kbhit.call != 0
                return true
            else 
                return false
            end
        end
        
        def _getch()
            return @@getch.call
        end

        def update()
            if _kbhit()
                @@key = _getch()
                @@pressed = true
            else
                @@pressed = false
            end
        end

        def down?(key_code)
            if @@pressed == true
                if key_code.class == String
                    @@key = @@key.chr
                elsif key_code.class == Fixnum
                end

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
