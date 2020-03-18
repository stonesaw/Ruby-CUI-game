# 参考 : https://qiita.com/kymmt@github/items/4dc72bcb04da7b90a3a1
# 　　 : https://melborne.github.io/2010/11/07/Ruby-ANSI/

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end

  def cyan
    colorize(36)
  end
  
  def white
    colorize(37)
  end

  def bg_black
    colorize(40)
  end

  def bg_red
    colorize(41)
  end

  def bg_green
    colorize(42)
  end

  def bg_yellow
    colorize(43)
  end

  def bg_pink
    colorize(45)
  end

  def bg_cyan
    colorize(46)
  end
  
  def bg_white
    colorize(47)
  end
end
