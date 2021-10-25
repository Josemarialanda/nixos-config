#!/run/current-system/sw/bin/bash

# copy config.nix and home.nix (home-manager) into nixos-config directory
cp -a /home/$USER/.config/nixpkgs/. ./home-manager/

# copy configuration.nix (system config) into nixos-config directory
cp /etc/nixos/configuration.nix ./system-config/configuration.nix

