class Scene
  def initialize(scenes, start: 0, ollinit: false)
    @@scenes = scenes
    @@num = start
    if ollinit
      @@scenes.length.times do |i|
        @@scenes[i].new
      end
    else
      @@scenes[@@num].new
    end
  end

  class << self  
    def update
      @@scenes[@@num].update
    end
    
    def draw
      @@scenes[@@num].draw
    end
    
    def next(init: false)
      @@num += 1
      raise StandardError.new("Scene.next scenes[#{@@num}] is Notfound!") if @@scenes.length - 1 < @@num
      @@scenes[@@num].new if init == true
    end

    def back(init: false)
      @@num -= 1
      raise StandardError.new("Scene.back scenes[#{@@num}] is Notfound!") if @@num < 0
      @@scenes[@@num].new if init == true
    end
    
    def select(scene, init: false)
      @@num = scene
      raise ArgumentError.new("Scene.select= scenes[#{@@num}] is Notfound!") if @@scenes.length - 1 < @@num
      @@scenes[@@num].new if init == true
    end

    def current
      return @@num
    end

    def scenes
      return @@scenes
    end

    def close
      exit
    end
  end
end
  