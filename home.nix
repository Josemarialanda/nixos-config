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
    gparted
    xclip
    tilix
    wget
    stress-ng
    s-tui
    smartmontools
    xorg.xkill

    # Programming and editors
    gnumake
    vscode
    gitg
    notepadqq
    valgrind
    maven
    llvm
    bison
    flex

    # Internet
    google-chrome
    transmission-gtk

    # Media
    spotify
    simplescreenrecorder

    # Office
    libreoffice-fresh
    texstudio
    texlive.combined.scheme-full
    lyx
    inkscape
    pdfslicer
    pandoc
  ];

  # Modules
  programs = {

  #  git = {
  #    enable = true;
  #    userName = "josemaria";
  #    userEmail = "josemaria.landa@gmail.com";
  #  };

    bat.enable = true;  # A better cat
    htop.enable = true; # System monitoring tool
    vscode.enable = true;            
  };

  # Xsession configuration
  xsession.enable = true;
  
  home.stateVersion = "21.05"; 
}
