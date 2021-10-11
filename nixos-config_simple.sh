#!/run/current-system/sw/bin/bash

  systemSync = pkgs.writeShellScriptBin "systemSync" ''
   
    DIR="/home/$USER/nixos-config/"
    
    if [ -d "$DIR" ]; then
      cd /home/$USER/nixos-config/

      echo "What changes have you made to Nix OS? (system or user)"
      read commitMsg

      echo "Retrieving latest user configuration..."
      cp /home/$USER/.config/nixpkgs/config.nix /home/$USER/nixos-config/
      cp /home/$USER/.config/nixpkgs/home.nix /home/$USER/nixos-config/
    
      echo "Retrieving latest system configuration..."
      cp /etc/nixos/configuration.nix /home/$USER/nixos-config/

      git add -A .
      git commit -m "$commitMsg"
      git branch -M main

      # store credentials (username and password must be supplied only once)
      git config credential.helper store
 
      echo "Syncing system configuration..."
      git push origin --all

    else
      echo "Cloning nixos-config..."

      # Setup git in case not already setup
      git config --global user.name "josemarialanda"
      git config user.email "josemaria.landa@gmail.com"

      git clone https://github.com/Josemarialanda/nixos-config.git
      cd /home/$USER/nixos-config

      cp ./config.nix /home/$USER/.config/nixpkgs/
      cp ./home.nix /home/$USER/.config/nixpkgs/
      
      # Setup home-manager
      nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
      nix-channel --update

      # Load user configuration
      home-manager switch

      echo "User configuration loaded"
    fi    