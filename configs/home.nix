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
      # themes = {};
    };
  };

  home.stateVersion = "21.05";
}
