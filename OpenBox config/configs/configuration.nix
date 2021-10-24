{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel parameters.
  # boot.kernelParams = [ ];

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the zen performance kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Kernel module for motherboard sensors.
  boot.kernelModules = [ "kvm-amd" "nct6775" ];

  # Upadte microcode.
  hardware.cpu.amd.updateMicrocode = true;  
  
  # Enable all firmware.
  # hardware.enableAllFirmware = true;

  # Enable all the redistributable firmware
  # hardware.enableRedistributableFirmware = true;

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

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;

    # Setup window manager.
    windowManager.openbox.enable = true;

    # Setup display manager.
    displayManager = {
      defaultSession = "none+openbox";
        lightdm = {
          enable = true;
          # background = # option is broken in NixOS 21.05
          greeters.gtk = {
            indicators = [ "~spacer" "~clock" "~spacer" "~power" ];
            theme = {
              name = "Lounge-night";
              package = pkgs.lounge-gtk-theme ;
            };
            iconTheme = {
              name = "Faba";
              package = pkgs.faba-icon-theme ;
            };
            cursorTheme = {
              name = "capitaine-cursors";
              package = pkgs.capitaine-cursors ;
              size = 32;
            }; 
          };
        };
    };
   
    # Make sure Xserver uses the amdgpu driver.
    videoDrivers = [ "amdgpu" ];
  }; 

  # Enable some services and programs needed to run a minimal window manager like openbox.
  services = {
    # Enable GNOME Keyring daemon.
    gnome.gnome-keyring.enable = true;
    # Enable GVfs, a userspace virtual filesystem.
    gvfs.enable = true;
  };
  
  # Auto-detects the connected display hardware and loads the appropriate X11 setup using xrandr.
  # services.autorandr.enable = true;

  # Needed in order to theme gtk with home-manager.
  programs.dconf.enable = true;

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
  environment.systemPackages = with pkgs; [ home-manager etcher ];

  # Enable and install Steam.
  programs.steam.enable = true; 

    # Enable OpenSSH.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  # Garbage collection.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 15d";
  systemd.timers.nix-gc.timerConfig.Persistent = true;

  system.stateVersion = "21.05"; 
}
