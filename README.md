# Monochrome-Ruby
__モノクロ Ruby__  
CUI(CLI)のゲーム用ライブラリ  

# Comment  
2020-春休み課題  
更新中... 

DXRubyのクラスや関数を参考にさせてもらっています(^__^)v  
かなり違うところもあるけど . . .  
Win32APIを使っています  

__需要 is nil !__

# Class 
(とりあえずリストだけ作ってみる)
- ## Map
    - ## Map.new(map: , text_hash, width: height: )
    - ## Map#draw(sprites_array) 
        sprites_array => [ sprite1, sprite2, ... ]
    - ## Map#text=(array)
        array => [ change_hash_number, new_text ]
    - ## Map#default_text=(text)
    - ## Map#default_text
    - ## Map#width
    - ## Map#height

- ## Sprite
    - ## Sprite.new(x, y, text)
    - ## Sprite.clean(sprite)
    - ## Sprite#hit(sprite)
    - ## Sprite#===(sprite)
        _same .hit_
    - ## Sprite#check(sprite)
        return hit sprite
    - ## Sprite#touch_head(sprite)
    - ## Sprite#touch_foot(sprite)
    - ## Sprite#touch_right(sprite)
    - ## Sprite#touch_left(sprite)
    - ## Sprite#vanish
    - ## Sprite#vanished?
    - ## Sprite#x
    - ## Sprite#x=(pos)
    - ## Sprite#y
    - ## Sprite#y=(pos)
    - ## Sprite#text
    - ## Sprite#text=()
    - ## Sprite#width
    - ## Sprite#height # TO DO
- ## Key
    - ## Key.down?(key)
    - ## Key.update
    - ## Key._kbhit
    - ## Key._getch
- ## Keys
    - ## Key::ESCAPE
    - ## Key::RETURN
