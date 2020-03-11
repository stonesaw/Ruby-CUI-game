# Monochrome-Ruby
__モノクロ Ruby__  
CUI(CLI)のゲーム用ライブラリ  

# Comment  
2020-春休み課題  
ライブラリは完成！

DXRubyのクラスや関数を参考にさせてもらっています(^__^)v  
かなり違うところもあるけど . . .  
Win32APIを使っています  

__需要 is nil !__

# Class 
(なんとなく作ってみる)
- ## Map
    - ## Map.new(map: [[]], text_hash: {0 => "  "}, width: map[0].length, height: map.length, default_text: -1)
        Mapオブジェクトを生成します。
    - ## Map#draw(sprite_ary = [])
        マップの全体を描画します。  
        引数にスプライトを入れることでそのスプライトを描画します。複数のスプライトを入れることが出来ます。 
    - ## Map#render_draw(ox, oy, width, height, sprite_ary = [])
        (ox, oy)から、(width, height)までのマップを表示します。Map#drawと同じようにスプライトを描画することが出来ます。
    - ## Map#text=(ary)
        ＊ary : [change_hash_number, new_text]  
        引数で渡された番号のテキストを変更します。
    - ## Map#map
        2次元配列のmapを返します。
    - ## Map#text_hash
        text_hashを返します。
    - ## Map#default_text=(str)
        デフォルトテキストを変更します。
    - ## Map#default_text
        デフォルトテキストを返します。
    - ## Map#width
        マップの幅を返します。
    - ## Map#height
        マップの高さを返します。
- ## Sprite
    - ## Sprite.new(x, y, text)
        スプライトを生成します。
    - ## Sprite.clean(ary)
        Sprite#vanishによって消されたスプライトを配列から削除します。
    - ## Sprite#hit(sprite, x: 0, y: 0)
        selfと渡されたspriteの衝突判定を行います。  
        x: , y: に値を入れることで離れた地点のスプライトとも衝突判定が出来ます。(もはや衝突判定じゃないw)
    - ## Sprite#===(sprite)
        Sprite#hitと似ていますがこちらはx: , y: を指定できません。  
        通常の衝突判定の場合はこちらを使用してください。  
        _same Sprite#hit_
    - ## Sprite#check(sprite)
        衝突しているスプライトを配列で返します。
        なにも衝突していない場合は空の配列を返します。
    - ## Sprite#touch(sprite)
        selfの上下左右に渡されたスプライトがある場合に真を返します。  
        **＊same Sprite#touch_(head or foot or right or left)**
    - ## Sprite#touch_head(sprite)
        selfの上に渡されたスプライトがある場合に真を返します。  
        __＊same Sprite#hit(sprite, y: -1)__
    - ## Sprite#touch_foot(sprite)
        selfの下に渡されたスプライトがある場合に真を返します。  
        __＊same Sprite#hit(sprite, y: 1)__
    - ## Sprite#touch_right(sprite)
        selfの右に渡されたスプライトがある場合に真を返します。  
        __＊same Sprite#hit(sprite, x: 1)__
    - ## Sprite#touch_left(sprite)
        selfの左に渡されたスプライトがある場合に真を返します。  
        __＊same Sprite#hit(sprite, x: -1)__
    - ## Sprite#vanish
        selfを削除します。
        削除されても配列には残りますが#drawや#hit, #checkでは無視されます。
    - ## Sprite#vanished?
        selfが削除されている場合に真を返します。
    - ## Sprite#x
        x座標を返します。
    - ## Sprite#x=(pos)
        x座標を変更します。
    - ## Sprite#y
        y座標を返します。
    - ## Sprite#y=(pos)
        y座標を変更します。
    - ## Sprite#text
        描画されるテキストを返します。
    - ## Sprite#text=(str)
        描画されるテキストを変更します。  
        2行以上の高さがある場合は配列で入れてください。  
        ＊ ["y=0", "y=1"]
    - ## Sprite#width
        テキストの幅を返します。  
        半角が0.5, 全角が1です。  
        切り上げの整数値を返します。
    - ## Sprite#height
        テキストの高さ(行数)を返します。
- ## Key
    - ## Key.update
        キーボード入力を更新します。  
        これをメインループないに書かないとキーボード入力が使用出来ません。
    - ## Key.down?(key)
        渡されたキーが押されている場合は真を返します。
        key : "a"(char) or KeyCode
- ## KeyCode
    - ## Key::ESCAPE
    - ## Key::RETURN
    - ## Key::UP
    - ## Key::DOWN
    - ## Key::RIGHT
    - ## Key::LEFT
    - ## Key::SPACE
