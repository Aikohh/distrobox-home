{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.programs.nushell.enable {
    programs.nushell.settings = {
      show_banner = false;
      buffer_editor = "hx";
    };
    programs.nushell.extraConfig =
      let
        completion_dir = "${pkgs.nu_scripts}/share/nu_scripts/custom-completions";
        completions = [
          "git"
          "zellij"
          "mask"
        ];
      in
      lib.concatMapStringsSep "\n" (
        cmplt: "source ${completion_dir}/${cmplt}/${cmplt}-completions.nu"
      ) completions;
  };
}
