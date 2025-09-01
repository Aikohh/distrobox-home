{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.programs.helix.enable {
    programs.helix.settings = {
      theme = "catppuccin_mocha";

      editor = {
        auto-save = true;
        bufferline = "always";
        cursorcolumn = true;
        cursorline = true;
        mouse = true;
        rulers = [80];
        text-width = 80;
        true-color = true;
      };

      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };

      editor.file-picker = {
        hidden = false;
      };

      editor.soft-wrap = {
        enable = true;
        wrap-at-text-width = false;
        wrap-indicator = "↩ ";
      };

      editor.statusline = {
        center = ["file-name"];
        left = ["mode" "spinner"];
        right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
        ];
        separator = "|";
      };

      editor.statusline.mode = {
        insert = "INSERT";
        normal = "NORMAL";
        select = "SELECT";
      };

      editor.whitespace.characters = {
        nbsp = "⍽";
        newline = "⏎";
        nnbsp = "␣";
        space = "·";
        tab = "→";
        tabpad = "·";
      };

      editor.whitespace.render = {
        nbsp = "none";
        newline = "all";
        nnbsp = "none";
        space = "none";
        tab = "all";
      };

      editor.indent-guides = {
        render = true;
      };

      editor.inline-diagnostics = {
        cursor-line = "hint";
      };
    };

    programs.helix.languages = {
      language-server.clangd = {
        # Use clangd from clang-tools to get a clangd that can find std headers
        command = "${pkgs.llvmPackages_latest.clang-tools.override { enableLibcxx = false; }}/bin/clangd";
      };

      language = [{
        name = "nix";
        scope = "source.nix";
        injection-regex = "nix";
        file-types = [ "nix" ];
        shebangs = [ ];
        comment-token = "#";
        language-servers = [ "nil" "nixd" ];
        indent = { tab-width = 2; unit = "  "; };
        formatter = { command = "nixfmt"; };
      }];
    };

    home.packages = with pkgs; [
      nixfmt-rfc-style
    ];
  };
}

