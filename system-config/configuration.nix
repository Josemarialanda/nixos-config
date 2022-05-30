# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable some kernel modules.
  boot.kernelModules = [ "kvm-amd" "nct6775" ];

  # Enable temperature readings.
  environment.etc = {
    "sysconfig/lm_sensors".text = ''
      HWMON_MODULES="nct6775"
    '';
  };

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Upadate microcode.
  hardware.cpu.amd.updateMicrocode = true;

  # Enable SSD TRIM support.
  services.fstrim.enable = true;

  # Load the correct gpu driver right away.
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Setup networking.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set time zone.
  time.timeZone = "America/Mexico_City";

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    port   = 5432;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
     '';
     initialScript = pkgs.writeText "backend-initScript" ''
       CREATE ROLE lendbot WITH LOGIN PASSWORD 'lendbot' CREATEDB;
       CREATE DATABASE ogmios-datum-cache;
       GRANT ALL PRIVILEGES ON DATABASE ogmios-datum-cache TO lendbot;
     '';
  };

  # Make sure Xserver uses the amdgpu driver.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable OpenCL.
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Enable Vulkan.
  hardware.opengl.driSupport = true;
  
  # For 32 bit applications.
  hardware.opengl.driSupport32Bit = true;

  # Configure keymap.
  services.xserver.layout = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;  

  # Enable bluetooth.
  hardware.bluetooth.enable = true;

  # User accounts.
  users.users.jose = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [ 
    wget
    gparted
    xclip
    xorg.xkill
    ffmpeg
    tilix
    gnome.gnome-tweaks
  ];

  # Enable udev rules for Ledger devices.
  hardware.ledger.enable = true;

  nix = {
     # Setup IOHK binary caches.
     binaryCaches          = [ "https://hydra.iohk.io" "https://iohk.cachix.org" ];
     binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=" ];

     # Enable flakes.
     package = pkgs.nixUnstable;
     extraOptions = ''
       experimental-features = nix-command flakes
     '';
     settings.substituters        = [ "https://public-plutonomicon.cachix.org https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/" ];
     settings.trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= public-plutonomicon.cachix.org-1:3AKJMhCLn32gri1drGuaZmFrmnue+KkKrhhubQk/CWc=" ];

     trustedUsers = [ "jose" ];
  };

  # Enable and install Steam.
  # programs.steam.enable = true;

  # Enable OpenSSH.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  programs.ssh.startAgent = true;

  # Automatic garbage collection and optimisation for newer derivations.
  # nix = {
  #  gc = {
  #    automatic = true;
  #    dates = "weekly";
  #    options = "--delete-older-than 30d";
  #  };
  #  autoOptimiseStore = true;
  # };

  system.stateVersion = "21.11";

}
