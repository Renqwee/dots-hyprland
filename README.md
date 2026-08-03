# dots-hyprland (Renqwee's Fork)

A customized fork of [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) with additional UI controls accessible directly from the settings panel.

## What's New

### Bar
- Shimmer effect opacity and background opacity controls
- Adjustable bar height from settings

### Dock
- Shimmer effect opacity and background opacity controls

### Workspaces
- Hover animation: icons scale up and lift when hovered
- Glow indicator showing current workspace position

## Installation

First, install the original dotfiles:
```bash
git clone https://github.com/end-4/dots-hyprland
cd dots-hyprland
./setup install
```

Then replace the config files with this fork:
```bash
git clone https://github.com/Renqwee/dots-hyprland ~/renqwee-dots

# Shell config -> Quickshell. rules.lua and repo metadata are not part of it.
rsync -a --exclude 'rules.lua' --exclude 'README.md' --exclude '.git' \
    ~/renqwee-dots/ ~/.config/quickshell/ii/

# Window opacity rules -> Hyprland. Kept here so dots-hyprland updates don't overwrite them.
mkdir -p ~/.config/hypr/custom
cp ~/renqwee-dots/rules.lua ~/.config/hypr/custom/
```

## Demo
[![Demo](https://img.youtube.com/vi/Tmu58NFF8Rw/maxresdefault.jpg)](https://youtu.be/Tmu58NFF8Rw)

## Credits
Based on [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)

## Contact
[![X](https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/renqwee)
[![Reddit](https://img.shields.io/badge/Reddit-FF4500?style=for-the-badge&logo=reddit&logoColor=white)](https://reddit.com/u/Hot-Patient5736)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Renqwee)
