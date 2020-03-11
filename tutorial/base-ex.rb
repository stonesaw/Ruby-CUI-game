#ruby -Ku
# ↑ 文字コードをUTF-8に設定する

# Monochrome-Rubyを読み込む
require_relative './../Monochrome-Ruby'

# 無限ループ
loop do
  # Key classのアップデート
  # これがないとキーボード入力が使えない
  Key.update

  # (Ctrl + c)で強制終了させるのは嫌なので(Esc)で終了する
  break if Key.down?(Key::ESCAPE)

  # 上はこれと同義
  # if Key.down?(Key::ESCAPE)
  #   break
  # end
end
