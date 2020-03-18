#ruby -Ku
require_relative './../Monochrome-Ruby'
require_relative './color'

# 参考 : https://qiita.com/kymmt@github/items/4dc72bcb04da7b90a3a1
# 　　 : https://melborne.github.io/2010/11/07/Ruby-ANSI/

puts "赤色で出力".red
puts "黄色で出力".yellow

puts "赤色で出力".bg_red
puts "黄色で出力".bg_yellow

puts "赤色で出力".bg_yellow.red
puts "黄色で出力".bg_red.yellow

puts "赤色で出力".red.bg_yellow
puts "黄色で出力".yellow.bg_red