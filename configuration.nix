{ config, pkgs, ... }:

let
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
    fi;    
  '';

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the zen performance kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Kernel module for motherboard sensors.
  boot.kernelModules = [ "kvm-amd" "nct6775" ];

  # Upadte microcode.
  hardware.cpu.amd.updateMicrocode = true;  

  # Load the correct gpu driver right away.
  boot.initrd.kernelModules = [ "amdgpu" ]; 

  # Setup networking.
  networking.hostName = "nixos";
  networking.networkmanager.enable = true; 
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;

  # Set time zone.
  time.timeZone = "America/Mexico_City";

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
  };

  # Setup desktop environment.
  services.xserver.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = true; # gdm is broken =/

  # Make sure Xserver uses the amdgpu driver.
  services.xserver.videoDrivers = [ "amdgpu" ]; 

  # Enable OpenCL
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Enable Vulkan
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  # Configure keymap.
  services.xserver.layout = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;  

  # User accounts
  users.users.jose = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager"];
  };  

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    systemSync
    home-manager 
  ];

  # Enable and install Steam.
  programs.steam.enable = true; 

    # Enable OpenSSH.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Garbage collection
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 15d";
  systemd.timers.nix-gc.timerConfig.Persistent = true;

  system.stateVersion = "21.05"; 
}
