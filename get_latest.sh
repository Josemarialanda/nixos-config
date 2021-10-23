#!/run/current-system/sw/bin/bash

# copy config.nix and home.nix (home-manager) into nixos-config directory
cp /home/$USER/.config/nixpkgs/config.nix ./configs/config.nix
cp /home/$USER/.config/nixpkgs/home.nix ./configs/home.nix

# copy configuration.nix (system config) into nixos-config directory
cp /etc/nixos/configuration.nix ./configs/configuration.nix

# delete old openbox and tint2 config directories
rm -r ./configs/openbox ./configs/tint2

# copy openbox config
cp -R /home/$USER/.config/nixpkgs/openbox ./configs/openbox

# copy tint2 config
cp -R /home/$USER/.config/nixpkgs/tint2 ./configs/tint2