#!/run/current-system/sw/bin/bash

# copy config.nix and home.nix (home-manager) into nixos-config directory
cp /home/$USER/.config/nixpkgs/config.nix ./configs/config.nix
cp /home/$USER/.config/nixpkgs/home.nix ./configs/home.nix

# copy configuration.nix (system config) into nixos-config directory
cp /etc/nixos/configuration.nix ./configs/configuration.nix

