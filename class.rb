class Sprite
    def initialize(x, y, text, z: 0)
        @x = x
        @y = y
        @z = z
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
    def initialize(map, char_ary)
        @@map = map
        @@char_ary = char_ary
        @@drawing = []
    end

    def self.draw
        @@map.length.times do |y|
            @@map[0].length.times do |x|
                flg = 0
                @@drawing.length.times do |a|
                    if (x == @@drawing[a].x && y == @@drawing[a].y)
                        print @@drawing[a].text
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
        return @@map[0].length
    end

    def self.height
        return @@map.length
    end
end
