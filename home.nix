{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  username,
  homeDirectory,
  gitUserName,
  gitUserEmail,
  ...
}:
{
  # ============================================================================
  # NIXPKGS CONFIGURATION
  # ============================================================================

  nixpkgs.overlays = [ outputs.overlays.stable-packages ];
  nixpkgs.config.permittedInsecurePackages = [ ];
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and new nix commands
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # ============================================================================
  # HOME MANAGER SETTINGS
  # ============================================================================

  targets.genericLinux.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Determines compatibility with Home Manager release
  # Update only after checking release notes for breaking changes
  home.stateVersion = "25.05";

  # ============================================================================
  # SHELL CONFIGURATION
  # ============================================================================

  home.shell.enableShellIntegration = true;

  home.shellAliases = {
    grep = "rg";
    cd = "z";
    cdi = "zi";
  };

  # ============================================================================
  # SHELL PROGRAMS
  # ============================================================================

  programs.bash.enable = true;

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      buffer_editor = "hx";
    };
    extraConfig =
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

  programs.carapace.enable = true;

  programs.zoxide.enable = true;

  # ============================================================================
  # TERMINAL UI PROGRAMS
  # ============================================================================

  programs.starship.enable = true;
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.eza.enable = true;
  programs.fastfetch.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;

  programs.ripgrep.enable = true;
  programs.ripgrep-all.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
    };
  };

  # ============================================================================
  # VERSION CONTROL
  # ============================================================================

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };
      core.editor = "hx";
      delta.navigate = true;
      delta.dark = true;
      merge.conflictstyle = "zdiff3";
    };
  };

  programs.delta.enableGitIntegration = true;
  programs.gh.enable = true;
  programs.gitui.enable = true;

  # ============================================================================
  # TEXT EDITOR
  # ============================================================================

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";

      editor = {
        auto-save = true;
        bufferline = "always";
        cursorcolumn = true;
        cursorline = true;
        mouse = true;
        rulers = [ 80 ];
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
        center = [ "file-name" ];
        left = [
          "mode"
          "spinner"
        ];
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

    languages = {
      language-server.clangd = {
        command = "${pkgs.llvmPackages_latest.clang-tools.override { enableLibcxx = false; }}/bin/clangd";
      };

      language = [
        {
          name = "nix";
          scope = "source.nix";
          injection-regex = "nix";
          file-types = [ "nix" ];
          shebangs = [ ];
          comment-token = "#";
          language-servers = [
            "nil"
            "nixd"
          ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };
  };

  # ============================================================================
  # PACKAGES
  # ============================================================================

  home.packages = with pkgs; [
    # CLI utilities
    dust # A better du (disk-use analyzer)
    dua # Interactive disk-use analyzer
    hyperfine # Benchmark timing tool
    mask # Markdown documentation that's also command runner like Make
    mprocs # Run multiple commands show the output of each
    steam-run # Run binaries in a FHS env
    presenterm # Presentations written in Markdown, rendered in-terminal
    opencode # AI coding assistant
    ollama-vulkan # LLM hosting

    # System utilities
    file # Show file type
    tree # Display directory trees
    xsel # Make system clipboard work

    # Compression
    zip # File compression and archiving
    unzip # zip decompression
    p7zip # 7zip

    # Nix tooling
    nixfmt # Nix formatter
    nil # An LSP for Nix
  ];

  home.sessionVariables = { };
}
