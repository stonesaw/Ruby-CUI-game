#ruby -Ku

require_relative './../Monochrome-Ruby'

Map.new(map: [
    [0,0,0,0,0,0,0,0],
    [0,0,0,1,0,1,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,0,0]],
text_hash: {
    0 => "・",
    1 => "■"
})

img = Sprite.new(0, 0, "○")

# main loop
loop do
    Map.update
    Key.update

    break if Key.down?(Key::ESCAPE)

    # sprite
    img.x += 1 if Key.down?("d")
    img.x -= 1 if Key.down?("a")
    img.y += 1 if Key.down?("s")
    img.y -= 1 if Key.down?("w")

    break if (img.x >= Map.width) || (img.y >= Map.height) || (img.x < 0) || (img.y < 0)

    puts "title"
    img.draw
    Map.draw
    puts "data ---"
end
