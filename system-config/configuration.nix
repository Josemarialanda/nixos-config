# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable kernel modules for temperature readings.
  boot.kernelModules = [ "kvm-amd" "nct6775" ];

  # Use the latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Upadate microcode.
  hardware.cpu.amd.updateMicrocode = true;

  # Enable SSD TRIM support.
  services.fstrim.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable OpenCL.
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Enable Vulkan.
  hardware.opengl.driSupport = true;
  
  # For 32 bit applications.
  hardware.opengl.driSupport32Bit = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
  programs.steam.enable = true; 

  # IOHK binary caches
  # nix = {
  #    binaryCaches          = [ "https://hydra.iohk.io" "https://iohk.cachix.org" ];
  #    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=" ];
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Automatic garbage collection and optimisation for newer derivations.
  # nix = {
  #  gc = {
  #    automatic = true;
  #    dates = "weekly";
  #    options = "--delete-older-than 30d";
  #  };
  #  autoOptimiseStore = true;
  # };

  system.stateVersion = "22.05";

}
