{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
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
    # julia-stable (marked as broken)     # Julia 
    (python3.withPackages pythonPackages) # Python

    # Tools
    # gparted
    wget
    bat
    xclip
    stress-ng
    s-tui
    mprime
    smartmontools
    xorg.xkill
    ffmpeg
    xarchiver
    sakura
    neofetch

    # Programming and editors
    gnumake
    gitg
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
    playerctl
    simplescreenrecorder
    vlc
    viewnior
    nitrogen
    scrot

    # Office
    libreoffice-fresh
    texstudio
    texlive.combined.scheme-full
    lyx
    inkscape
    pdfslicer
    pandoc
    leafpad

    # System
    polkit_gnome
    pcmanfm
    libmtp
    pnmixer
    tint2
    xsettingsd
    lxappearance
    obconf
    pavucontrol
    bluez
    bluez-tools
  ];

  #  Modules
  programs = {
    git = {
      enable = true;
      userName = "josemarialanda";
      userEmail = "josemaria.landa@gmail.com";
    };
    rofi = {
      enable = true;
      # other config   
    };
  };
  services = {
    # gnome-keyring.enable = true;
    # blueman-applet.enable = true;
    dunst = {
      enable = true;
	settings = {
	    global = {
	      font = "cinnamonroll 11";
		    markup = "full";
		    plain_text = "no";
        format = "format = <b>%s</b>\n%b";
        sort = "yes";
		    indicate_hidden = "yes";
		    alignment = "left";
		    bounce_freq = 0;
		    show_age_threshold = 60;
		    word_wrap = "yes";
		    ignore_newline = "no";
		    stack_duplicates = "false";
		    hide_duplicate_count = "yes";
		    geometry = "300x60-28+28";
		    shrink = "no";
		    idle_threshold = 120;
		    follow = "mouse";
		    sticky_history = "yes";
		    history_length = 15;
		    show_indicators = "no";
        browser = "google-chrome-stable -new-tab";
        always_run_script = true;
		    line_height = 4;
		    separator_height = 0;
		    padding = 32;
		    horizontal_padding = 32;
		    separator_color = "frame";
		    startup_notification = false;
        icon_position = "off";
        max_icon_size = 80;
        frame_width = 2;
        frame_color = "#8EC07C";
	    };
        urgency_low = {
          frame_color = "#141c21";
          foreground = "#93a1a1";
          background = "#141c21";
          #timeout = 1;
        };

        urgency_normal = {
          frame_color = "#141c21";
          foreground = "#93a1a1";
          background = "#141c21";
          #timeout = 1;
        };

        urgency_critical = {
          frame_color = "#141c21";
          foreground = "#93a1a1";
          background = "#141c21";
          #timeout = 1;
        };
	  };
    };
    gnome-keyring.enable = true;
    picom = {
      enable = true;
      vSync = true;
      experimentalBackends = true;
      refreshRate = 75;
    };
  };
  
  # Openbox configuration
  home.file.".config/openbox/autostart".source = ./openbox/autostart;
  home.file.".config/openbox/menu.xml".source  = ./openbox/menu.xml;
  home.file.".config/openbox/rc.xml".source    = ./openbox/rc.xml;
  # Tint2 configuration
  home.file.".config/tint2/tint2rc".source     = ./tint2/tint2rc;
  
  home.stateVersion = "21.05"; 
}
