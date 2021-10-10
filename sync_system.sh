#!/run/current-system/sw/bin/bash

github_username= "josemarialanda"
github_token="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"

if [ -d .git ]; then
  echo "Syncing system configuration files to git repo..."
  echo "Access token: $github_token"
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

git add -A .
git commit -m "$commitMsg"
git branch -M main
# git push -u origin main
git push -u https://$github_username:$github_token@nixos-config.git

