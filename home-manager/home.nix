{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  username,
  ...
}:
{
  nixpkgs.overlays = [ outputs.overlays.stable-packages ]; # Overlay stable pkgs to pkgs.stable
  nixpkgs.config.permittedInsecurePackages = [ ];
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  targets.genericLinux.enable = true;

  # User specifications
  home.username = username;
  home.homeDirectory = "/home/${username}/distrobox-home";

  imports = [
    ./modules
  ];

  # Programs and Features

  programs.bash.enable = true;
  programs.nushell.enable = true;
  programs.carapace.enable = true;

  programs.starship.enable = true;
  programs.bat.enable = true; # A better cat
  programs.btop.enable = true; # Display running processes
  programs.eza.enable = true; # A better ls
  programs.fastfetch.enable = true; # Display system information
  programs.fd.enable = true; # A better find
  programs.fzf.enable = true; # A fuzzy finder
  programs.ripgrep.enable = true; # A better grep
  programs.ripgrep-all.enable = true; # ripgrep that works in container files (PDF, epub, etc...)
  programs.yazi.enable = true; # A better ranger
  programs.zellij.enable = true; # A better tmux
  programs.zoxide.enable = true; # A better cd

  programs.git.enable = true;
  programs.delta.enableGitIntegration = true; # A better diff and pager for git
  programs.gh.enable = true; # GitHub CLI
  programs.gitui.enable = true; # Terminal UI for git

  programs.helix.enable = true;
  programs.helix.defaultEditor = true;

  home.packages = with pkgs; [
    dust # A better du (disk-use analyzer)
    dua # Interactive disk-use analyzer
    hyperfine # Benchmark timing tool
    mask # Markdown documentation that's also command runner like Make
    presenterm # Presentations written in Markdown, rendered in-terminal
    mprocs # Run multiple commands show the output of each
    file # Show file type
    tree # Display directory trees
    zip # File compression and archiving
    unzip # zip decompression
    p7zip # 7zip
    steam-run # Run binaries in a FHS env
    valgrind-light # Debugging and profiling
    lldb # Debugging
    nil # An LSP for Nix
    nodejs # JS
    wine64 # Wine
    vkd3d-proton # DX12 to VK
    nss_latest # Required for some windows exes to run
    xsel # Make system clipboard work
  ];

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
