#!/run/current-system/sw/bin/bash

# copy config.nix and home.nix (home-manager) into nixos-config directory
cp /home/$USER/.config/nixpkgs/config.nix ./config.nix
cp /home/$USER/.config/nixpkgs/home.nix ./home.nix


# copy configuration.nix (system config) into nixos-config directory
cp /etc/nixos/configuration.nix ./configuration.nix

# copy openbox config
cp -R /home/$USER/.config/nixpkgs/openbox ./openbox

# copy tint2 config
cp -R /home/$USER/.config/nixpkgs/tint2 ./tint2