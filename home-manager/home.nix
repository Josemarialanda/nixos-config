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
      
      # Session variables
      sessionVariables = {
        TEST = 10;
      };
      
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
     
        home = "cd ~/";        
      };
      
      # Bash config file
      bashrcExtra = ''                 
        
      '';
      
      # Commands that should be run when initializing an interactive shell
      initExtra = ''
        cowthink "MOO?" | lolcat 
      '';
    };
  };

  # Dracula color scheme for tilix
  home.file.".config/tilix/schemes/Dracula.json".source = themes/tilix/Dracula.json;
  
  # Dracula color scheme for gedit
  home.file.".local/share/gedit/styles/dracula.xml".source = themes/gedit/dracula.xml;

  home.stateVersion = "21.05";
}
