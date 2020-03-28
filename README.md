# Monochrome-Ruby
__モノクロ Ruby__  
CUI(CLI)のゲーム用ライブラリ

- Ruby 2. 6. 5  
- Ruby 2. 1. 6  
で動作確認済み  
Win32APIを使っているため、おそらくMacでは使用不可

# 使い方
git clone, ZIPファイルなどでダウンロードしてrequire(_relative)すれば使えます。  
サンプルやチュートリアルも少しですが作りました。

# Comment  
2020-春休み課題  

DXRubyのクラスや関数を参考にさせてもらっています(^_^)v  
かなり変わったけど . . .  
Win32APIを使ってます。

__需要 is nil !__

# Reference
- ## Map Class
    - ## Map.new(map: [[]], text_hash: {0 => "  "}, width: map[0].length, height: map.length, default_text: -1)
        Mapオブジェクトを生成します。
    - ## Map#draw(sprite_ary = [])
        マップの全体を描画します。  
        引数にスプライトを入れることでそのスプライトを描画します。複数のスプライトを入れることが出来ます。 
    - ## Map#render_draw(ox, oy, width, height, sprite_ary = [])
        (ox, oy)から、(width, height)までのマップを表示します。Map#drawと同じようにスプライトを描画することが出来ます。
    - ## Map#text=(ary)
        ＊ary : [hash_number_or_symbol, new_text]  
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
- ## Sprite Class
    - ## Sprite.new(x, y, text)
        スプライトを生成します。
    - ## Sprite.clean(ary)
        Sprite#vanishによって消されたスプライトを配列から削除します。
    - ## Sprite#hit(sprite, x: 0, y: 0)
        selfと渡されたspriteの衝突判定を行います。  
        x: , y: に値を入れることで離れた地点のスプライトとも衝突判定が出来ます。(もはや衝突判定じゃない...)
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
        _＊same Sprite#hit(sprite, y: -1)_
    - ## Sprite#touch_foot(sprite)
        selfの下に渡されたスプライトがある場合に真を返します。  
        _＊same Sprite#hit(sprite, y: 1)_
    - ## Sprite#touch_right(sprite)
        selfの右に渡されたスプライトがある場合に真を返します。  
        _＊same Sprite#hit(sprite, x: 1)_
    - ## Sprite#touch_left(sprite)
        selfの左に渡されたスプライトがある場合に真を返します。  
        _＊same Sprite#hit(sprite, x: -1)_
    - ## Sprite#vanish
        selfを削除します。
        削除されても配列には残りますが#drawや#hit, Sprite.checkでは無視されます。
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
        描画されるテキストを配列で返します。
    - ## Sprite#text=(str)
        描画されるテキストを変更します。  
        2行以上の高さがある場合は配列で入れてください。  
        ```  
        sp1.text = ["ｃ", "人"]
        # 描画した結果 =>
        # ｃ
        # 人
        ```
    - ## Sprite#width
        テキストの幅を返します。  
        半角が0.5, 全角が1です。  
        切り上げの整数値を返します。
    - ## Sprite#height
        テキストの高さ(行数)を返します。
- ## Key Class
    - ## Key.update
        キーボード入力を更新します。  
        これをメインループないに書かないとキーボード入力が使用出来ません。
    - ## Key.down?(key)
        渡されたキーが押されている場合は真を返します。  
        Boolean(真または偽)を返すため基本的に次のような使い方をします。  
        ```
        if Key.down?(key_code)
          # ...
        end
        ```
        a-z, 0-9,その他記号などは、文字列を引数に渡します  
        例)
        ```
        if Key.down?("a")
        if Key.down?("0")
        ```
- ## KeyCode
    |KeyCode|キー|
    |:---|:---|
    |Key::ESCAPE | エスケープ
    |Key::RETURN|エンター
    |Key::UP|矢印(上)
    |Key::DOWN|矢印(下)
    |Key::RIGHT|矢印(右)
    |Key::LEFT|矢印(左)
    |Key::SPACE|スペース
    |Key::BACKSPACE|バックスペース
    |Key::DELETE|デリート
    |Key::TAB|タブ
    |Key::HOME|ホーム
    |Key::K_END|エンド
    |Key::PAGEUP|ページアップ
    |Key::PAGEDOWN|ページダウン
    |Key::INSERT | インサート
    |Key::F1|F1
    |Key::F2|F2
    |Key::F3|F3
    |Key::F4|F4
    |Key::F5|F5
    |Key::F6|F6
    |Key::F7|F7
    |Key::F8|F8
    |Key::F9|F9
    |Key::F10|F10
    |Key::F11|F11
    |Key::F12|F12
- Key::ANY  
    何かのキーが押されたときに真を返す
