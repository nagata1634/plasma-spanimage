# Span Image

English | [日本語](README.ja.md)

[KDE Store](https://store.kde.org/p/2374313/) · [GitHub](https://github.com/nagata1634/plasma-spanimage)

A KDE Plasma 6 wallpaper plugin that shows **one image spanning all monitors**.

Plasma has no built-in wallpaper spanning ([KDE Bug 393781](https://bugs.kde.org/show_bug.cgi?id=393781),
open since 2018). Instead of slicing the image per monitor with ImageMagick, this plugin does it in
QML: Plasma creates one wallpaper instance per screen, so each instance draws the image scaled to
the whole virtual desktop, shifted by its own screen position, and clipped to its screen.

- Resolution, scale factor, rotation and offsets are already reflected in Qt's virtual-desktop
  (logical px) coordinates; the wallpaper follows output changes automatically
- KDE's stock wallpapers (directory-style KPackages with light/dark variants) work via `MediaProxy`
- The settings page is the familiar thumbnail grid of the standard "Image" wallpaper
  (`org.kde.image` QML, reused)
- Settings page in English or Japanese, by locale

## Requirements

- KDE Plasma 6 (Wayland or X11)
- `kpackagetool6` (ships with Plasma)

## Install

```sh
git clone https://github.com/nagata1634/plasma-spanimage.git
cd plasma-spanimage
./install.sh            # kpackagetool6 install
./install.sh --link     # development: symlink
./install.sh --uninstall
```

Right-click the desktop › Configure Desktop and Wallpaper › **Wallpaper type** › "Span Image", then
pick an image. If it doesn't show up, reload with `plasmashell --replace &`.

## Settings

- Image (thumbnail grid, or "Add…" for a file)
- Margin color (visible when the image's aspect ratio differs from the virtual desktop;
  default `#002b36`)

**Pick the image on any one screen and Apply; the other screens follow automatically** (Plasma keeps wallpaper settings per screen, so the plugin writes the same value to the other screens through plasmashell's scripting API).

### Login screen (Plasma Login Manager)

`./install.sh --system /path/to/image.jpg` installs the plugin into `/usr/local/share` (via pkexec); then choose "Span Image" under System Settings › Login Screen › Wallpaper type. The greeter runs as the `plasmalogin` user, so the image must live somewhere world-readable such as `/usr/local/share/wallpapers/`.

Config keys mirror `org.kde.image` (`Image` / `Color` / `FillMode` / `Blur`) because the reused
thumbnail UI references `cfg_*` directly.

## License

GPL-2.0-or-later.

`contents/ui/ThumbnailsComponent.qml`, `WallpaperDelegate.qml` and `AddFileDialog.qml` are taken
from the `org.kde.image` wallpaper in KDE plasma-workspace (GPL-2.0-or-later; Marco Martin,
Kai Uwe Broulik, David Redondo, Sebastian Kügler, Fushan Wen and others) with only the plugin id
changed. See the SPDX headers in each file.
