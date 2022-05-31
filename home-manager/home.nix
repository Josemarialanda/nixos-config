{ config, pkgs, ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [

    # Text and code editors.
    vscode

    # Internet
    google-chrome
    fragments
   
    # Media
    spotify
    simplescreenrecorder

    # Office
    texstudio
    texlive.combined.scheme-full
    lyx
    pandoc

    # CLI apps
    htop
    pfetch
    stress-ng
    s-tui
    mprime
    dmidecode
    ventoy-bin
  ];

  # Modules
  programs = {

    # Install the Java development kit and set the JAVA_HOME variable.
    java.enable = true;

    # Configure git
    git = {
      enable = true;
      userName = "josemarialanda";
      userEmail = "josemaria.landa@gmail.com";
    };

    # Enable bat: a better cat
    bat = {
      enable = true;
      config = {
        theme = "Dracula";
        style = "numbers,changes,header,grid";
      };
    };

    # Enable starship prompt
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        character.success_symbol = "[λ](bold green)";
        character.error_symbol = "[ERROR!](bold red)";  
      };
    };

    # Bash configuration
    bash = {
      enable = true;

      # Shell aliases
      shellAliases = {

        # Variations of ls
        ll = "ls -l";
        lo = "ls -o";
        lh = "ls -lh";
        la = "ls -la";

        # confirm before overwriting something
        "cp" = "cp -i";
        "mv" = "mv -i";
        "rm" = "rm -i";

        # git
        addup = "git add -u";
        addall = "git add .";
        branch = "git branch";
	      checkout = "git checkout";
	      clone = "git clone";
	      commit = "git commit -m";
	      fetch = "git fetch";
	      pull = "git pull origin";
	      push = "git push origin";
	      stat = "git status";
	      tag = "git tag";
	      newtag = "git tag -a";

        # get error messages from journalctl
        jctl = "journalctl -p 3 -xb";
         
        # Disk space information
        diskspace = "du -S | sort -n -r |more";
    
        # Show the size (sorted) of the folders in this directory
        folders = "find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn";

        # Aliases for moving up directories
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # NixOS aliases
        nixos-config = "sudo $EDITOR /etc/nixos/configuration.nix";
        nixos-sync-now = "sudo nixos-rebuild switch";  
        nixos-sync-boot = "sudo nixos-rebuild boot";      
        nixos-undo = "sudo nixos-rebuild switch --rollback";
        nixos-update = "sudo nix-channel --update"; # nixos-update <channel-alias> updates only one channel
        nixos-update-undo = "sudo nix-channel --rollback";
        nixos-channels = "sudo nix-channel --list";
        nixos-channel-add = "sudo nix-channel --add";
        nixos-channel-remove = "sudo nix-channel --remove";
        nixos-generations = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nixos-clean = "sudo nix-collect-garbage -d"; # system cleanup
        nixos-optimise = "nix-store --optimise";

        # home-manager aliases
        home-config = "home-manager edit";
        home-sync = "home-manager switch";
        home-generations = "home-manager generations";
        home-remove-generation = "home-manager remove-generations";
        home-list = "home-manager packages";

        # nix-env aliases
        nix-install = "nix-env -i";
        nix-search = "nix search";
        nix-undo = "nix-env --rollback";
        nix-generations = "nix-env --list-generations";
        nix-upgrade = "nix-env -u";
        nix-remove = "nix-env -e";
        nix-list = "nix-env --query";
        nix-clean = "nix-collect-garbage -d"; # user specific cleanup         
      };

      # Bash config file
      bashrcExtra = ''
        export EDITOR='kak'
        export VISUAL='kak'  
      '';
      
      # Commands that should be run when initializing an interactive shell
      initExtra = ''
         
      '';
    };

    kakoune = {
      enable = true;
      config = {
	    tabStop = 2;
      alignWithTabs = true;
      autoComplete = [ "insert" "prompt" ];
      autoInfo = [ "command" "onkey" ];
      autoReload = "ask";
      colorScheme = "dracula";
      indentWidth = 0;
      numberLines = {
        enable = true;
        highlightCursor = true;
        separator = "|";
      };
      ui = {
        enableMouse = true;
        assistant = "dilbert";
        setTitle = true;
      };
      wrapLines = {
        enable = true;
        indent = true;
        marker = "⏎";
      };
    };
    plugins = [ 
      pkgs.kakounePlugins.powerline-kak
      pkgs.kakounePlugins.kakoune-rainbow
      pkgs.kakounePlugins.kakoune-vertical-selection
    ];
    extraConfig = ''
      set-face global Default rgb:f8f8f2,default
    '';
    };
  };

  # Dracula color scheme for tilix
  home.file.".config/tilix/schemes/Dracula.json".source = themes/tilix/Dracula.json;
  
  # Dracula color scheme for kakoune
  home.file.".config/kak/colors/dracula.kak".source = themes/kakoune/dracula.kak;

}
