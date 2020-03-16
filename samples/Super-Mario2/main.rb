#ruby -Ku
require_relative './../../Monochrome-Ruby'
require_relative './../scene-editor'
require_relative './class'
require_relative './title-life'
require_relative './play'
require_relative './menu'
require_relative './result'

# マリオの画面遷移などを追加
# 各シーンごとにファイルを分割
# 画面(マップ)の大きさは17 * 14
WIDTH = 17
HEIGHT = 14
# rubyでは定数に代入が出来てしまうので.freezeで値を固定(定数に)する
WIDTH.freeze
HEIGHT.freeze

# ここで使うシーンを配列に入れる
# シーンは'title-life', 'play', 'menu'で定義
Scene.new([
  Title,
  Life,
  Play,
  Menu,
  GameOver,
  GameClear
])

# メインループ
loop do
  # キーボードのアップデート
  Key.update

  # 最初のシーンでエスケープキーが押されたときに終了
  break if Key.down?(Key::ESCAPE) && Scene.current == 0

  # 画面を全て消す
  system("cls")

  # 現在のシーンをアップデート・描画
  Scene.update
  Scene.draw
end
