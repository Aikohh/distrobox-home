{ config, lib, pkgs, gitUsername, gitEmail, ... }:
{
  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      userName  = "Aikoh";
      userEmail = "127701152+Aikohh@users.noreply.github.com";
      extraConfig = {
        # Helix as default editor
        core.editor = "hx";
        # Delta options
        delta.navigate = true;
        delta.dark = true;
        merge.conflictstyle = "zdiff3";
      };
    };
  };
}

