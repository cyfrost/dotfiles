# dotfiles

This repo contains some of my config files

## Backup and Restore

### Guake Terminal Config

Backup:
```
gconftool-2 --dump /apps/guake > apps-guake.xml
gconftool-2 --dump /schemas/apps/guake > schemas-apps-guake.xml
```
Restore:
```
gconftool-2 --load apps-guake.xml
gconftool-2 --load schemas-apps-guake.xml
```

### Tilix Config

Backup:

`dconf dump /com/gexperts/Tilix/ > tilix_config`

Restore:

`dconf load /com/gexperts/Tilix/ < tilix_config`

or

`curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/tilix_conf.dconf" | dconf load /com/gexperts/Tilix/`

### Dash To Panel config

Backup:

`dconf dump /org/gnome/shell/extensions/dash-to-panel/ > dash_to_panel.config`

Restore:

`dconf load /org/gnome/shell/extensions/dash-to-panel/ < dash_to_panel.config`
