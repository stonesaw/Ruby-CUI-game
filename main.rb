#ruby -Ku
require 'io/console' #TO DO
require_relative './class'

Map.new([
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
],
[
    "・",
    "mm"
])

img = Sprite.new(0, 0, "ｃ")

count = 0
loop do
    count += 1
    Map.update

    #sprite
    img.x += 1 if (count % 10) == 0
    img.y += 1 if (count % 20) == 0
    img.draw
    Map.draw
    break if (img.x >= Map.width || img.y >= Map.width)
end
