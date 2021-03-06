# <p align="center">🌸 Bliss 🌸</p>
![image](https://user-images.githubusercontent.com/13358601/166813201-3e1ee8f5-02dd-4bab-a935-0c980ce04567.png)
## Software
- Distro: arch
- AUR Helper: paru
- Display Manager: slim
- Window Manager: leftwm
- Wallpaper Drawer: feh
- Image Viewer: nsxiv
- Compositer: picom-animations-git
- App Launcher: rofi
- Theme Manager: lxappearance, qt5ct
- Icon Theme: flatery
- Widget Theme: orchis
- Mouse Cursor: phinger
- Terminal: alacritty
- Text Editor: neovim
- Browser: vivaldi
- File Managers: thunar (gvfs, tumbler), joshuto (p7zip)
- Video Player: mpv
- Font Packages: ttf-liberation, ttf-symbola
- Terminal Stuff: macchina, cbonsai, shell-color-scripts
- Apps: blender, krita, eww, discord (discocss), spotify, steam, heroic games launcher, retroarch, rpcs3-git, polymc (jre-openjdk), obs-studio, chatterino2-7tv-git (gst-plugins-good), bottom, blueman, xp-pen-tablet, zathura (zathura-pdf-mupdf), dunst, jp2a, wmctrl, playerctl, graphicsmagick
## Reminders
- To make executable bash file: `chmod +x /script/path`
- Change ownership: `chown (username) /file/path`
- In `/etc/pacman.conf`: ParallelDownloads=4, uncomment multilib and color
- Out of sync kernel and driver updates can cause system to break
- Remove gnu-free-fonts, install ttf-symbola (aur) (for alacritty braille to render as dots on graphs)
- Install ttf-liberation for steam
- If you need to edit an AUR PKGBUILD, use `paru --fm nvim -S (pakage name)`
- `7z x *.zip -o\*` to extract zip into folder with same name
- append `/mini` to the "Exec" line in `/etc/xdg/autostart/xppentablet.desktop` to start xp-pen-tablet minimized
- add `x-gvfs-show` to partition option in `/etc/fstab` to have it appear in thunar
- Change grub timeout with `se /etc/defaults/grub` and run `sudo grub-mkconfig -o /boot/grub/grub.cfg`
