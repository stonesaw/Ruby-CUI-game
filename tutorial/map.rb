#ruby -Ku
require_relative './../Monochrome-Ruby'

map = Map.new(
map: [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
], text_hash: {0 => "  ", 1 => "□"})

loop do
  Key.update
  system("cls")

  break if Key.down?(Key::ESCAPE)

  map.draw
end
