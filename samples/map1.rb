#ruby -Ku
require_relative './../class'

Map.new(map: [
    [1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,0,2,0,0,3,3,0,0,1],
    [1,0,2,0,3,0,0,3,0,1],
    [1,0,2,0,0,3,3,0,0,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1]],
text_hash: {
    0 => "  ",
    1 => "■",
    2 => "□",
    3 => "○"
})

count = 0
loop do
    Map.update
    Key.update
    count += 1

    break if Key.down?(Key::ESCAPE)

    if (count % 20) == 0
        Map.text = [2, "■"]
        Map.text = [3, "●"]
    elsif (count % 10) == 0
        Map.text = [2, "□"]
        Map.text = [3, "○"]
    end
    Map.draw
end
