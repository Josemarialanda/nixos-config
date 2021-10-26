{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.packages = let

  # Python packages
  pythonPackages = pkgs: with pkgs; [
    numpy
    pylint
    pandas
    matplotlib
    scipy
    sympy
    seaborn
    scikitlearn
    tabulate
    ipykernel
    setuptools
    ipywidgets
    ];

  in with pkgs; [

    # Compilers
    stack                                 # Haskell
    jdk                                   # Java
    gcc                                   # GNU compiler collection
    idris2                                # Idris
    clean                                 # Clean
    clisp                                 # Common lisp
    gforth                                # GNU Forth
    rustup                                # Rust
    julia-stable                          # Julia 
    (python3.withPackages pythonPackages) # Python

    # Programming and editors
    gnumake
    valgrind
    maven
    llvm
    bison
    flex
    vscode

    # Internet
    google-chrome
    transmission-gtk

    # Media
    spotify
    simplescreenrecorder

    # Office
    texstudio
    texlive.combined.scheme-full
    lyx
    pandoc
    retext

    # CLI apps
    lolcat
    fortune
    boxes
    cowsay
    asciiquarium
    figlet
    htop
    thefuck
    pfetch
    stress-ng
    s-tui

    # Cursor themes
    bibata-cursors

    # GTK/Shell themes

    # Icon themes
    papirus-icon-theme

    # Gnome extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection

  ];

  # Modules
  programs = {
        
    # Configure git
    git = {
      enable = true;
      userName = "josemarialanda";
      userEmail = "josemaria.landa@gmail.com";
    };

    # Enable lazygit git cli interface
    lazygit.enable = true;

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
     
        home = "~";

        # NixOS aliases
        nixos-config = "sudo $EDITOR /etc/nixos/configuration.nix";
        nixos-sync-now = "sudo nixos-rebuild switch";  
        nixos-sync-boot = "sudo nixos-rebuild boot";      
        nixos-undo = "nixos-rebuild switch --rollback";
        nixos-update = "sudo nix-channel --update"; # nixos-update <channel-alias> updates only one channel
        nixos-update-undo = "nix-channel --rollback";
        nixos-channels = "nix-channel --list";
        nixos-channel-add = "nix-channel --add";
        nixos-channel-remove = "nix-channel --remove";
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
        # set kakoune as default text editor
        export EDITOR='kak'
        export VISUAL='kak'
        # enable thefuck
        eval "$(thefuck --alias)"  
      '';
      
      # Commands that should be run when initializing an interactive shell
      initExtra = ''
        cowthink "MOO?" | lolcat 
      '';
    };

    kakoune = {
      enable = true;
      config = {
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
  
  # Dracula color scheme for gedit
  home.file.".local/share/gedit/styles/dracula.xml".source = themes/gedit/dracula.xml;
  
  # Dracula color scheme for kakoune
  home.file.".config/kak/colors/dracula.kak".source = themes/kakoune/dracula.kak;

  home.stateVersion = "21.05";
}
