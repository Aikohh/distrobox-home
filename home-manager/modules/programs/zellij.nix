{ config, lib, ... }:
{
  config = lib.mkIf config.programs.zellij.enable {
    programs.zellij.settings = {
      show_startup_tips = false;
    };
  };
}

