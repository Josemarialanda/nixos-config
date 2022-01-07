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

  # Setup the IOHK binary caches to build Plutus.
  nix = {
     binaryCaches          = [ "https://hydra.iohk.io" "https://iohk.cachix.org" ];
     binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=" ];
  };

  # Enable and install Steam.
  # programs.steam.enable = true; 

  # Enable OpenSSH.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Automatic garbage collection and optimisation for newer derivations.
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    autoOptimiseStore = true;
  };

  system.stateVersion = "21.11";

}
