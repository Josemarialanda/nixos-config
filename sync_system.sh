#!/run/current-system/sw/bin/bash

if [ -d .git ]; then
  echo "Syncing system configuration files to git repo..."
else
  echo "Setting up local git repository"
  git init
  git remote add origin https://github.com/Josemarialanda/nixos-config.git
fi;

echo "Please enter commit message"
read commitMsg

# retrieve latest user configuration
cp ../.config/nixpkgs/config.nix ./
cp ../.config/nixpkgs/home.nix ./

# retrieve latest system configuration
cp /etc/nixos/configuration.nix ./

git add .

git commit -m "$commitMsg"
git branch -M main
git push -u origin main