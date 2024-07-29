
nix
{
  description = "A flake for PC Bio Unlock. Unlock your PC with your Android phone.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            openssl
            libgcc
            libxcrypt
            pkg-config
            makeWrapper
            boost
            spdlog
            kdePackages.qtbase 
            kdePackages.qttools 
            kdePackages.qtdeclarative
            kdePackages.extra-cmake-modules
            kdePackages.wrapQtAppsHook  
          ];
        };
      };
    );
}
