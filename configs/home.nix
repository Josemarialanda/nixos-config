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
    neofetch

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
    playerctl
    simplescreenrecorder
    vlc
    viewnior
    nitrogen
    scrot

    # Office
    texstudio
    texlive.combined.scheme-full
    lyx
    epdfview
    pandoc
    retext
    leafpad

    # System
    polkit_gnome
    pcmanfm
    libmtp
    tint2
    obconf
    xsettingsd
    pavucontrol
    bluez
    bluez-tools
  ];

  xdg.enable = true; 

  #  Modules
  programs = {
    git = {
      enable = true;
      userName = "josemarialanda";
      userEmail = "josemaria.landa@gmail.com";
    };
    lazygit.enable = true;
    kitty = {
      enable = true;
      environment = {};
      extraConfig = ''

        # UI
        background_opacity 0.8
        
        # Cursor
        cursor_text_color #FF0000
        cursor_stop_blinking_after 10.0
        
        # Scrollback
        scrollback_lines 500
        
        # Mouse
        mouse_hide_wait 10.0
        url_color #30e310
        url_prefixes http https ftp mailto news git www
        url_style curly
        copy_on_select yes

        # Tab bar
        tab_bar_edge top
        tab_bar_style powerline
        tab_powerline_style slanted
        tab_activity_symbol 🔥🔥🔥
        
        # Color scheme
        # Dracula theme
	background #1e1f28
	foreground #f8f8f2
	cursor #bbbbbb
	selection_background #44475a
	color0 #000000
	color8 #545454
	color1 #ff5555
	color9 #ff5454
	color2 #50fa7b
	color10 #50fa7b
	color3 #f0fa8b
	color11 #f0fa8b
	color4 #bd92f8
	color12 #bd92f8
	color5 #ff78c5
	color13 #ff78c5
	color6 #8ae9fc
	color14 #8ae9fc
	color7 #bbbbbb
	color15 #ffffff
	selection_foreground #1e1f28

      '';
      font = {
        name = "Source Code Pro";
        size = 14;
        package = pkgs.source-code-pro;
      };
      keybindings = {    
      };
    };
    rofi = {
      enable = true;
      # other config   
    };
  };
  services = {
    # gnome-keyring.enable = true;
    # gpg-agent.enable = true;
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
      extraOptions = ''
        use-damage = true;
      '';
    };
  };


  fonts.fontconfig.enable = true;
  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
      size = 12;
      package = pkgs.pkgs.dejavu_fonts;
    };
    iconTheme = {
      name = "Faba";
      package = pkgs.faba-icon-theme;
    };
    theme = {
      name = "Lounge-night";
      package = pkgs.lounge-gtk-theme;
    };
  };

  xsession = {
    enable = true;
    pointerCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 32;
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
