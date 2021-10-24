{ config, pkgs, ... }:

{
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    extraGroups = [ "wheel" "networkmanager"];
  };  

  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Enable home-manager.
  environment.systemPackages = with pkgs; [ 
    wget
    gparted
    xclip
    xorg.xkill
    ffmpeg
    tilix
    gnome.gnome-tweaks
  ];

  # Enable and install Steam.
  # programs.steam.enable = true; 

  # Enable OpenSSH.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Garbage collection.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 15d";
  systemd.timers.nix-gc.timerConfig.Persistent = true;   

  system.stateVersion = "21.05";
}

