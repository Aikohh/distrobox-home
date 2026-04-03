{
  description = "Nix Home Manager flake for user configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        inherit (self) outputs;

        # ====================================================================
        # USER CONFIGURATION
        # Adjust these values to match your system and preferences
        # ====================================================================

        # Your system username
        username = "aikoh";

        # Your home directory path
        # Change if your home directory is not at /home/<username>/distrobox-home
        homeDirectory = "/home/${username}/distrobox-home";

        # Git user configuration
        gitUserName = "Aikoh";
        gitUserEmail = "127701152+Aikohh@users.noreply.github.com";

        # ====================================================================

      in
      {
        overlays = import ./overlays { inherit inputs; };

        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              username
              homeDirectory
              gitUserName
              gitUserEmail
              ;
          };
          modules = [
            ./home-manager/home.nix
          ];
        };
      }
    );
}
