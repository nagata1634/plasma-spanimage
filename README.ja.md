# Span Image（スパン画像）

[English](README.md) | 日本語

[KDE Store](https://store.kde.org/p/2374313/) · [GitHub](https://github.com/nagata1634/plasma-spanimage)

1 枚の画像を**複数モニタにまたがって**表示する KDE Plasma 6 の壁紙プラグインです。

Plasma には壁紙のスパン機能がありません（[KDE Bug 393781](https://bugs.kde.org/show_bug.cgi?id=393781)、
2018 年からの未実装要望）。ImageMagick でモニタごとに切り出す代わりに、QML だけで完結します:
壁紙インスタンスは画面ごとに 1 つ生成されるので、各インスタンスが「仮想デスクトップ全体のサイズに
引き伸ばした画像」を自分の画面位置ぶんマイナス方向へずらして描き、親で clip すればスパンになります。

- 解像度・拡大率・回転・オフセットはすべて Qt の仮想デスクトップ座標（論理 px）に反映済み。
  出力構成を変えると自動で追従します
- KDE 標準の壁紙（ディレクトリ形式の KPackage、ライト/ダーク変種）も `MediaProxy` 経由で読めます
- 設定ページは標準の「画像」壁紙と同じサムネイル一覧（`org.kde.image` の QML を流用）

## 必要なもの

- KDE Plasma 6（Wayland / X11）
- `kpackagetool6`（Plasma に同梱）

## インストール

```sh
git clone https://github.com/nagata1634/plasma-spanimage.git
cd plasma-spanimage
./install.sh            # kpackagetool6 で導入
./install.sh --link     # 開発用: symlink
./install.sh --uninstall
```

デスクトップを右クリック › 壁紙を設定 › **壁紙の種類** で「スパン画像 (Span Image)」を選び、画像を選択します。
一覧に出ない場合は `plasmashell --replace &` で再読み込みしてください。

## 設定

- 画像（サムネイル一覧から選択、または「追加」でファイルを指定）
- 余白の色（画像の縦横比が仮想デスクトップと違うときに見える部分。既定 `#002b36`）

**どれか 1 つの画面で選んで [適用] すれば、他の画面にも同じ画像が配られます**（Plasma の壁紙設定は画面ごとに独立しているため、プラグインが plasmashell のスクリプティング API で他の画面へ同じ値を書きます）。

### ログイン画面（Plasma Login Manager）

`./install.sh --system /path/to/image.jpg` で `/usr/local/share` に導入し（pkexec）、System Settings › ログイン画面 › 壁紙の種類 で「スパン画像」を選びます。ログイン画面は `plasmalogin` ユーザーで動くので、画像も `/usr/local/share/wallpapers/` など全員が読める場所に置く必要があります。

キー名は `org.kde.image` に合わせてあります（`Image` / `Color` / `FillMode` / `Blur`）。
流用しているサムネイル UI が `cfg_*` を直に参照するためです。

## ライセンス

GPL-2.0-or-later。

`contents/ui/ThumbnailsComponent.qml` / `WallpaperDelegate.qml` / `AddFileDialog.qml` は
KDE plasma-workspace の `org.kde.image` 壁紙（GPL-2.0-or-later、Marco Martin / Kai Uwe Broulik /
David Redondo / Sebastian Kügler / Fushan Wen ほか）からプラグイン ID の差し替え程度の変更で
流用しています。各ファイルの SPDX ヘッダを参照してください。
