#!/usr/bin/env bash
# Span Image 壁紙プラグインを現在のユーザーに導入する（root 不要・冪等）。
#
#   ./install.sh          kpackagetool6 で導入（コピー）
#   ./install.sh --link   このリポジトリへの symlink を張る（開発用）
#   ./install.sh --uninstall
#   ./install.sh --system [画像]   ログイン画面(plasmalogin)用に /usr/local/share へ導入(pkexec)。
#                                  画像を渡すと /usr/local/share/wallpapers/ にもコピーする
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ID=dev.yuya.spanimage
DEST="$HOME/.local/share/plasma/wallpapers/$PKG_ID"
ok() { printf '\033[1;32m✓\033[0m %s\n' "$*"; }

case "${1:-}" in
  --uninstall)
    if [ -L "$DEST" ]; then rm -f "$DEST"; else kpackagetool6 -t Plasma/Wallpaper -r "$PKG_ID" >/dev/null 2>&1 || rm -rf "$DEST"; fi
    ok "Span Image をアンインストールしました（壁紙の種類を他に戻してください）"; exit 0 ;;
  --link)
    [ -d "$DEST" ] && [ ! -L "$DEST" ] && kpackagetool6 -t Plasma/Wallpaper -r "$PKG_ID" >/dev/null 2>&1 || true
    mkdir -p "$(dirname "$DEST")"; ln -sfn "$HERE/package" "$DEST"; ok "symlink: $DEST" ;;
  "")
    [ -L "$DEST" ] && rm -f "$DEST"
    if [ -d "$DEST" ]; then kpackagetool6 -t Plasma/Wallpaper -u "$HERE/package" >/dev/null; else kpackagetool6 -t Plasma/Wallpaper -i "$HERE/package" >/dev/null; fi
    ok "導入: $DEST" ;;
  --system)
    # ログイン画面(plasmalogin greeter)は plasmalogin ユーザーで動くため ~/.local は見えない。
    # /usr/local/share は XDG_DATA_DIRS の既定に含まれ、Fedora Atomic でも書ける(/var/usrlocal)。
    SYS=/usr/local/share/plasma/wallpapers/$PKG_ID; IMG="${2:-}"
    pkexec sh -c "rm -rf '$SYS' && mkdir -p '$(dirname "$SYS")' && cp -r '$HERE/package' '$SYS' && chmod -R a+rX '$SYS'$( [ -n "$IMG" ] && printf ' && mkdir -p /usr/local/share/wallpapers && cp %q /usr/local/share/wallpapers/ && chmod a+r /usr/local/share/wallpapers/%q' "$IMG" "$(basename "$IMG")" )"
    ok "システム導入: $SYS"; [ -n "$IMG" ] && ok "画像: /usr/local/share/wallpapers/$(basename "$IMG")"
    echo "System Settings › ログイン画面 › 壁紙の種類 で「スパン画像 (Span Image)」を選び、/usr/local/share/wallpapers/ の画像を指定してください。"; exit 0 ;;
  *) echo "usage: $0 [--link|--uninstall|--system [image]]" >&2; exit 2 ;;
esac
echo "デスクトップを右クリック › 壁紙を設定 › 壁紙の種類 で「スパン画像 (Span Image)」を選んでください。"
echo "一覧に出ない場合: plasmashell --replace &"
