{ pkgs, config, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./modules/alacritty.nix
    ./modules/common-pkgs.nix
    ./modules/direnv.nix
    ./modules/firefox.nix
    ./modules/git.nix
    ./modules/gpg.nix
    ./modules/mail.nix
    ./modules/rime-fcitx.nix
    ./modules/rust.nix
    ./modules/shell
    ./modules/tmux.nix
    ./modules/trash.nix
    ./modules/user-dirs.nix
    ./modules/vim
    ./modules/vscode

    ./plugins/hm-desktop-autostart.nix
  ];

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
