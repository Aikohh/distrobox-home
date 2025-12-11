{ config, lib, ... }:
{
  config = lib.mkIf config.programs.git.enable {
    programs.git.settings = {
      user = {
        name  = "Aikoh";
        email = "127701152+Aikohh@users.noreply.github.com";
        signingkey = "~/.ssh/id_ed25519.pub";
      };
      # Helix as default editor
      core.editor = "hx";
      # Delta options
      delta.navigate = true;
      delta.dark = true;
      merge.conflictstyle = "zdiff3";
    };
  };
}

