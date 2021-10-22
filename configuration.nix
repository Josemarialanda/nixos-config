{ config, pkgs, ... }:

let
  nixos-sync = pkgs.writeShellScriptBin "nixos-sync" ''
   
	DIR="/home/$USER/nixos-config/"
	gitconfig="/home/$USER/.gitconfig"
	firstrun="/home/$USER/.firstrun"
	version=21.05

	# First run
	if [ ! -f $firstrun ]; then
	  echo -e "Welcome to nixos-sync $version\n
	  To use nixos-sync you must:
		* Set git username and address:
			Set your username: git config --global user.name <username>
			Set your email address: git config --global user.email <name@example.com>

		* Setup Home Manager.

		* Create a github repo named nixos-config.

	  Only the first sync will ask you to enter your github username and personal access token.\n"
	  touch $firstrun
	else
	  echo -e "nixos-sync $version\n"
	fi

	if [ ! -f $gitconfig ]
	  then
		echo "Please setup git first:"
		echo "  Set your username: git config --global user.name <username>"
		echo "  Set your email address: git config --global user.email <name@example.com>"
	  else      
		cd /home/$USER/
		# check if nixos-config directory exists
		if [ -d "$DIR" ]; then
		  # if it exists, cd into directory
		  cd /home/$USER/nixos-config/

		  echo "What changes have you made to Nix OS? (system or user)"
		  read commitMsg

		  echo "Retrieving latest user configuration..."
		  # copy config.nix and home.nix (home-manager) into nixos-config directory
		  cp /home/$USER/.config/nixpkgs/config.nix /home/$USER/nixos-config/
		  cp /home/$USER/.config/nixpkgs/home.nix /home/$USER/nixos-config/

		  echo "Retrieving latest system configuration..."
		  # copy configuration.nix (system config) into nixos-config directory
		  cp /etc/nixos/configuration.nix /home/$USER/nixos-config/

		  git add -A .
		  git commit -m "$commitMsg"
		  git branch -M main

		  # store credentials (username and password must be supplied only once)
		  git config credential.helper store

		  echo "Syncing system configuration..."
		  git push origin --all

		else # first time running nixos-sync
		  echo "Have you setup Home Manager? [yes/no]"
		  read yesno
		  if [ $yesno = "no" ]; then
			echo "First setup home manager:"
			echo ""
			# Setup home-manager (Nix OS 21.05)
			echo "1)	  nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager"
			echo "2)	  nix-channel --update"
			echo "	  You will most likely have to logout and login again to use the channel"
			echo "3)	  nix-shell '<home-manager>' -A install"
			echo "4)	  home-manager switch"
		  elif [ $yesno = "yes" ]; then
			echo "Have you setup a Github repo (named nixos-config) to store the configuration files? [yes/no]"
			read yesno
			if [ $yesno = "no" ]; then
			  echo "First setup a Github repo to store configuration files"
			elif [ $yesno = "yes" ]; then
			  echo "Enter the repo address: e.g: https://github.com/<github-username>/nixos-config.git"
			  read repo_name

			  echo "Cloning nixos-config..."
			  git clone $repo_name

			  cd /home/$USER/nixos-config

			  echo "Sync Nix OS with Github repo? [yes/no]"
			  read yesno
			  if [ $yesno = "yes" ]; then

				# copy configuration.nix (system config) into nixos-config directory
				cp /etc/nixos/configuration.nix /home/$USER/nixos-config/

				# copy config.nix and home.nix (home-manager) into nixos-config directory
				cp ./config.nix /home/$USER/.config/nixpkgs/
				cp ./home.nix /home/$USER/.config/nixpkgs/

				git add -A .
				git commit -m "$commitMsg"
				git branch -M main

				# store credentials (username and password must be supplied only once)
				git config credential.helper store
				echo "Syncing system configuration..."
				git push origin --all
			  else
				echo "To sync Nix OS run nixos-sync"
			  fi
			else
			  echo "Not yes or no"
			fi  
		  else
			echo "Not yes or no"
		fi
	  fi    
	fi

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
  services.gvfs.enable = true;
  programs.nm-applet.enable = true;
  services.xserver.windowManager.openbox.enable = true;
  services.xserver.displayManager.defaultSession = "none+openbox";
  services.xserver.displayManager.lightdm.enable = true;

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
    nixos-sync
    home-manager
    etcher
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
