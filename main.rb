#ruby -Ku

require_relative './class'

Key.new()
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
], width: 30,height: 10)

img = Sprite.new(Map.width / 2, Map.height / 2, "ｃ")

# main loop
loop do
    # TO DO 
    # update系は main loop内に隠しといておきたい
    Map.update
    Key.update

    break if Key.down?(Key::ESCAPE)
    break if Key.down?(Key::RETURN)
    
    # sprite
    img.x += 1 if Key.down?("d")
    img.x -= 1 if Key.down?("a")
    img.y += 1 if Key.down?("s")
    img.y -= 1 if Key.down?("w")

    img.x += 1 if Key.down?("6")
    img.x -= 1 if Key.down?("4")
    img.y += 1 if Key.down?("8")
    img.y -= 1 if Key.down?("2")
    
    break if (img.x >= Map.width) || (img.y >= Map.height) || (img.x < 0) || (img.y < 0)
    
    img.draw
    Map.draw
end
