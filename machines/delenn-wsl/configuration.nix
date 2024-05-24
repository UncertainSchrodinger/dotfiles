{ inputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Switch to latest from the default LTS kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ZFS lags behind kernel releases. You WILL get errors all the time when you
  # try to update if you enable zfs. Hence we disable it.
  boot.supportedFilesystems.zfs = lib.mkForce false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # These are based on Arch Linux defaults:
  #   https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem/-/blob/main/sysctl
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches"   = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # Games are known to exhaust this:
    #   https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/
    "vm.max_map_count"  = 1048576;
  };

  networking.hostName = "virtualbox"; # Define your hostname.
  networking.nameservers = [
    "9.9.9.9" # quad9
    "1.1.1.1" # cloudflare
  ];

  networking.dhcpcd = {
    enable = true;

    # TODO(tatu): I should really configure a static IP or do something about
    # this. DHCP takes like 10 seconds on NixOS. This should make it so that it
    # doesn't wait for IP.
    wait = "background";

    extraConfig = ''
    noarp
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # TODO(tatu): Why does NixOS recommend enabling this?
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraMono"]; })
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;

    # TODO(tatu): Should move this, hardware dependent
    # videoDrivers = ["nvidia"];

    windowManager.i3 = {
      enable = true;
    };

    displayManager = {
      # Login to vtty. I don't want a graphical user login, it's just useless
      # crap. When there's an issue with the system it's almost always due to
      # the GUI. It's super rare in linux nowadays, but why would I waste my
      # life on a solution that opens the path to failure when I can have a path
      # where it cannot ever exist?
      startx.enable = true;

    };

    xkb = {
      # Enable Finnish layout
      layout = "fi";

      # Map capslock to escape
      options = "caps:escape";
    };

    # I'm still unsure if I should just use the nix options or my old
    # configuration files.
    extraConfig = builtins.readFile ../../dotfiles/X11/50-mouse-acceleration.conf;

    excludePackages = with pkgs; [
      xterm
    ];
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Still need to set password with 'passwd' after creation.
  users.users.kuglimon = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    createHome = true;
    packages = with pkgs; [
      alacritty
      alacritty-theme

      # the 'bash' package is a minimal bash installation meant for scripts and
      # automation. We want the full package for interactive use.
      bashInteractive
      bat
      btrfs-progs
      cargo
      docker
      docker-buildx
      dosfstools
      dunst
      feh
      flameshot
      fuse3
      fzf
      gcc
      git
      git-crypt
      git-lfs
      go
      imagemagick
      jq
      keepassxc
      killall
      nodejs_latest
      (polybar.override { i3Support = true; })
      pulsemixer
      rclone
      ripgrep
      rofi
      rustc
      tmux
      tree
      unzip
      xclip
      zsh
      zsh-completions

      # Not sure if there's a cleaner way to reference packages from custom
      # repositories.
      inputs.rojekti.packages.${system}.default
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # If GPG complains about missing pinentry then try rebooting the machine.
  # There's likely some configuration error, too lazy to debug it now.
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.git.lfs.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

