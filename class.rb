require 'Win32API'

class Sprite
    def initialize(x, y, text)
        @x = x
        @y = y
        if text == "" || text == nil
            puts "ERROR: Sprite.text"
            puts "i dont know '' or nil"
            exit
        else
            @text = text
        end
    end

    def draw
        Map.drawing << self
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
end

class Map
    def initialize(map, char_ary, width: map[0].length, height: map.length)
        @@map = map
        @@char_ary = char_ary
        @@drawing = []
        @@width = width
        @@height = height
        if @@width < @@map[0].length
            puts "ERROR : Map#width"
            exit
        elsif @@width > @@map[0].length
            need = @@width - @@map[0].length
            @@map.length.times do |i|
                need.times do
                    @@map[i] << 0
                end
            end
        end
        if @@height < @@map.length
            puts "ERROR : Map#height"
            exit
        elsif @@height > @@map.length
            need = @@height - @@map.length
            need.times do |i|
                x_ary = []
                @@width.times do
                    x_ary << 0
                end
                @@map << x_ary
            end
        end
    end

    def self.draw
        @@map.length.times do |y|
            @@map[0].length.times do |x|
                flg = 0
                @@drawing.length.times do |i|
                    if (x == @@drawing[i].x && y == @@drawing[i].y)
                        print @@drawing[i].text
                        flg = 1
                        next
                    end
                end
                print @@char_ary[@@map[y][x]] if flg == 0
            end
            puts ""
        end
    end
    
    def self.update
        @@drawing = []
        system("cls")
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
