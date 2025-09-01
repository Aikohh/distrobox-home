# My Home Manager config for generic Linux systems with distrobox

```
mkdir ~/distrobox-home
distrobox create --image <image> --home ~/distrobox-home
distrobox enter <box>
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
nix-shell -p home-manager git
git clone https://github.com/Aikohh/home-manager-generic.git ~/nix
home-manager switch --flake ~/nix
```
