# my-rice

Kubuntu rice: KDE Plasma + i3 + polybar + rofi + kitty + spicetify + pywal
(automatic wallpaper-driven color palette switching).

## Structure

Everything under `home/` mirrors `$HOME`, so a file at
`home/.config/kitty/kitty.conf` belongs at `~/.config/kitty/kitty.conf`.

```
.
├── collect-dotfiles.sh   # run on your live machine to (re)populate home/
├── install.sh            # symlinks home/ back into $HOME on a new machine
├── home/
│   ├── .config/
│   │   ├── i3/
│   │   ├── polybar/
│   │   ├── rofi/
│   │   ├── kitty/
│   │   ├── spicetify/
│   │   ├── wal/               # pywal templates
│   │   ├── kdeglobals, kwinrc, plasma*  # KDE Plasma
│   │   └── dolphinrc
│   ├── .cache/wal/            # current pywal-generated palette (not history)
│   ├── .local/bin/            # custom scripts, incl. wallpaper switcher
│   └── .xinitrc / .Xresources / .bashrc / etc.
└── .collect-log.txt      # stderr from the last collection run (gitignored)
```

## Regenerating this repo from your live machine

```bash
./collect-dotfiles.sh          # copies current configs into ./home
git add -A
git commit -m "update rice"
git push
```

## Installing on a fresh machine

```bash
git clone <this-repo> ~/dotfiles-rice
cd ~/dotfiles-rice
./install.sh
```

This creates symlinks, so any file you already have in `$HOME` gets backed
up to `<file>.bak` first, then a symlink into the repo takes its place.
Editing a config afterward edits the repo copy directly.

You'll also need the actual packages installed for anything to work:
`i3`, `polybar`, `rofi`, `kitty`, `dolphin`, `spicetify-cli`, and `pywal`
(`pip install pywal` or your distro's package).

## Wallpaper-driven color switching

The pywal setup watches/uses the wallpaper picker script under
`home/.local/bin` (or `home/.config/i3/scripts` if that's where
`collect-dotfiles.sh` found it referenced from your i3 config) to run
`wal -i <image>` against your picture folder, which regenerates
`~/.cache/wal/colors*` and the templates in `~/.config/wal/templates/`.
Kitty, rofi, and polybar are configured to `include`/source the
generated palette files, so a wallpaper change cascades everywhere.

Double check `home/.local/bin` after running the collector - if your
switcher script lives somewhere non-standard, just copy it manually into
`home/` under its correct relative path before committing.

## Notes

- `.cache/wal/` in this repo intentionally only keeps the *current*
  palette, not your full wallpaper history — that folder grows fast.
- Review `home/` before your first commit. Some KDE files (like
  `kwinoutputconfig.json`) can contain machine-specific display info
  you may not want to carry to another machine — delete if irrelevant.
