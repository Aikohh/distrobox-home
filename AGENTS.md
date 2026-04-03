# AGENTS.md - Nix Home Manager Configuration

## Project Overview

This is a Home Manager flake configuration for generic Linux systems with distrobox.
It manages user-level packages and programs for the user "aikoh".

## Build Commands

```bash
# Apply the configuration (build and activate)
home-manager switch --flake ~/nix

# Dry run to see what would be built
home-manager dry-activate --flake ~/nix

# Build without activating
nix build .#homeConfigurations.aikoh.activationPackage

# Update flake inputs
nix flake update

# Show flake outputs
nix flake show

# Clean up old generations
home-manager expire-generations -1

# Collect garbage (remove unused nix store entries)
nix-collect-garbage
```

## Linting and Formatting

```bash
# Format all .nix files with nixfmt-rfc-style (RFC style formatting)
nixfmt **/*.nix

# Check formatting without modifying files
nixfmt --check **/*.nix

# Validate flake outputs
nix flake check

# Build configuration without activating (validates config)
nix build .#homeConfigurations.aikoh.activationPackage
```

## Code Style Guidelines

### General Conventions

- Use **2-space indentation** for all .nix files
- Use **nixfmt-rfc-style** for automatic formatting
- Files should end with a **newline**
- Keep lines **under 80 characters** where reasonable
- Use **kebab-case** for file names (e.g., `home-shell.nix`, not `homeShell.nix`)

### Attribute Names

- Use **camelCase** for Nix built-in attributes (`homeDirectory`, `homeManager`, `stateVersion`)
- Use **kebab-case** for user-defined module options (`buffer-editor`, not `bufferEditor`)
- Group related settings under nested attributes (e.g., `editor.cursor-shape`, `editor.statusline`)

### Imports Organization

```nix
{
  imports = [
    # Modules first
    ./modules

    # Then individual files
    ./modules/dotfiles.nix
    ./modules/homeShell.nix
  ];
}
```

### Module Structure Pattern

```nix
{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.programs.<name>.enable {
    # Program-specific settings
  };
}
```

### Overlays Pattern

```nix
{ inputs, ... }:
{
  stable-packages = final: prev: {
    # Overlay content
  };
}
```

### Flake Output Pattern

```nix
{
  description = "Description";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # ...
  };

  outputs =
    {
      self,
      nixpkgs,
      # ...
    }@inputs:
    {
      # outputs
    };
}
```

### Lists vs Attrsets

- Use **lists** `[ ]` for ordered collections of simple values
- Use **attrset** `{ }` for key-value pairs and nested configuration
- Use **lists** for file-types, language-servers, and similar arrays
- Use **attrsets** for theme settings, editor config, and structured data

### String Syntax

- Use **double quotes** for regular strings: `"value"`
- Use **angle bracket syntax** for derivations: `"${pkgs.package}/bin/cmd"`
- Use **single quotes** only for literal strings with no interpolation

### Boolean Values

- Use **true** and **false** (lowercase, no quotes)
- Prefer `lib.mkIf` over `lib.optional` for conditional blocks

### Comments

- Use `#` for single-line comments
- Place comments on their own line, above the relevant code
- Use descriptive comments for non-obvious configurations:
  ```nix
  # Use clangd from clang-tools to get a clangd that can find std headers
  command = "${pkgs.llvmPackages_latest.clang-tools}/bin/clangd";
  ```

### Package Listings

```nix
home.packages = with pkgs; [
  # Group by function, add brief comments for non-obvious tools
  dust # A better du (disk-use analyzer)
  dua # Interactive disk-use analyzer
];
```

### Attribute Ordering Within Files

1. Shebang / Nixpkgs module header
2. `config`, `lib`, `pkgs`, `inputs`, `outputs`, `username` parameters
3. `imports` declaration
4. `options` block (if custom options defined)
5. `config` block
6. Program settings ordered by logical groupings

### Library Functions

- Use `lib.mkIf` for conditional configuration
- Use `lib.concatMapStringsSep` for joining strings
- Use `lib.mkOption` for custom options
- Always `inherit` variables from scope when passing to submodules

### Error Handling

- Rely on Nix's lazy evaluation for catching errors at build time
- Use `lib.assertMsg` for runtime assertions if needed
- Avoid `builtins.trace` in production code

### Nixpkgs Overlays

- Overlay files should be in `./overlays/default.nix`
- Use `final: prev:` pattern for overlay functions
- Expose overlays via the flake's `outputs.overlays`

## Key Files

- `flake.nix` - Flake entry point, defines inputs and outputs
- `home-manager/home.nix` - Main configuration, imports all modules
- `home-manager/modules/` - Modular program configurations
- `home-manager/modules/programs/` - Individual program settings
- `overlays/default.nix` - Custom package overlays

## Dependencies

- Nix 2.18+ with flakes enabled
- Home Manager (from `github:nix-community/home-manager`)
- `nixfmt-rfc-style` for formatting
