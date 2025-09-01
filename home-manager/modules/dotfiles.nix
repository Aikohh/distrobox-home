{ config, lib, ... }:
{
  options = {
    # (Impure) A function returning an absolute path to files in the dotfiles folder that remains outside of the nix store.
    # Usage:
    # home.file."filepath/relative/to/home".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/filepath/relative/to/config.dotfiles";
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/nix/home-manager/dotfiles";
      example = "${config.home.homeDirectory}/nix/home-manager/dotfiles";
      description = "Location of dotfiles";
    };
  };
}
