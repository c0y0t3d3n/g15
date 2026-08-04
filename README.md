# G15
Logitech g15 utilities patched to work on current Debian

`install.sh` will ensure prerequisites, clone g15stats and g15macro repos, patch, build, and install. Needs to sudo, enter password when prompted.

`g15daemon.service` replaces the unit file from the g15daemon package to fix a shutdown hang in Ubuntu.\
`g15stats.service` ensures g15stats runs at boot. change `-i eno2` to match your network interface for network stats.\
`g15macro.desktop` adds an app in Gnome, etc... if you want it to start at login add it to your autostarts.
