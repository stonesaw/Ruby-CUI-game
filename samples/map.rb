#ruby -Ku
require_relative './../Monochrome-Ruby.rb'

map = Map.new(map: [
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
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)
  
  if (count % 20) == 0
    map.text = [2, "■"]
    map.text = [3, "●"]
  elsif (count % 10) == 0
    map.text = [2, "□"]
    map.text = [3, "○"]
  end
  map.draw
  
  count += 1
end
