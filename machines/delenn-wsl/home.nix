{ pkgs, ... }:

{
  home.username = "kuglimon";
  home.homeDirectory = "/home/kuglimon";

  # Home-manager has programs that can configure all of these through a DSL,
  # but I think that's ultimately bad for you.
  #
  # You should learn how to use the underlying tools and how to configure them,
  # it similar to using GUI apps for terminal apps. There are a crap ton of
  # other reasons:
  #
  # * Your friends are probably not using NixOS
  # * Maybe you have a mac and don't use nix there
  # * Your coworkers can't help you with issues
  # * You cannot help your coworkers
  # * Likely you'll never really learn from mistakes
  # * Googling for configuration is multiple layers
  home.file.".aliases".source = ../../dotfiles/aliases;

  home.file.".ssh/config".source = ../../dotfiles/ssh/config;

  home.file.".gemrc".source = ../../dotfiles/gemrc;

  home.file.".git_template".source = ../../dotfiles/git_template;
  home.file.".gitconfig".source = ../../dotfiles/gitconfig;
  home.file.".gitconfig-work".source = ../../dotfiles/gitconfig-work;
  home.file.".gitignore".source = ../../dotfiles/gitignore;
  home.file.".gitmessage".source = ../../dotfiles/gitmessage;

  home.file.".psqlrc".source = ../../dotfiles/psqlrc;
  home.file.".rspec".source = ../../dotfiles/rspec;

  home.file.".local/bin" = {
    source = ../../dotfiles/bin;
    recursive = true;
    executable = true;
  };

  home.file.".tmux.conf".source = ../../dotfiles/tmux.conf;
  home.file.".config/tmux" = {
    source = ../../dotfiles/tmux;
    recursive = true;
  };

  home.file.".config/nvim/init.lua".source = ../../dotfiles/nvim/init.lua;
  home.file.".config/nvim/lua" = {
    source = ../../dotfiles/nvim/lua;
    recursive = true;
  };

  home.file.".zsh/functions" = {
    source = ../../dotfiles/zsh/functions;
    recursive = true;
  };
  home.file.".zshenv".source = ../../dotfiles/zshenv;
  home.file.".zshrc".source = ../../dotfiles/zshrc;

  home.file.".config/alacritty/alacritty.toml".source = ../../dotfiles/alacritty/alacritty.toml;
  home.file.".config/alacritty/override.toml".source = ../../dotfiles/alacritty/linux.toml;
  home.file.".config/alacritty/catppuccin/catppuccin-mocha.toml".source = "${pkgs.alacritty-theme}/catppuccin_mocha.toml";

  home.file.".xinitrc".source = ../../dotfiles/xinitrc;
  home.file.".config/i3/config".source = ../../dotfiles/i3/config;

  home.file.".config/polybar/config.ini".source = ../../dotfiles/polybar/config.ini;
  home.file.".config/polybar/launch.sh" = {
    source = ../../dotfiles/polybar/launch.sh;
    executable = true;
  };

  home.file.".config/rofi" = {
    source = ../../dotfiles/rofi;
    recursive = true;
  };

  home.file."Images" = {
    source = ../../dotfiles/wallpapers;
    recursive = true;
  };

  home.file.".config/dunst/dunstrc".source = ../../dotfiles/dunst/dunstrc;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  xsession = {
    enable = true;
    pointerCursor = {
      # size = 40;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
  };
}
