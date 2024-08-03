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
        devShells = pkgs.mkShell {
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

        packages.${system}.default = {
          pname = "pcbuDesktop";
          version = "2.0.3";
          src = self;

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
          buildPhase = ''
            mkdir -p build
            cd build
            cmake .. -DCMAKE_BUILD_TYPE=Release \
                    -DCMAKE_INSTALL_PREFIX=$out \
                    -DTARGET_ARCH=x64
            cmake --build . --target install 
          '';

          # Wrap and Configure
          installPhase = ''
            # Desktop entry and icon (adjust paths as needed)
            mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
            cp ./linux/PCBioUnlock.desktop $out/share/applications/pcbuDesktop.desktop
            cp ./desktop/res/icons/icon.png $out/share/icons/hicolor/256x256/apps/pcbuDesktop.png

            sed -i 's|Icon=PCBioUnlock|Icon=pcbuDesktop|' $out/share/applications/pcbuDesktop.desktop
            sed -i 's|Exec=pcbu_desktop|Exec=pcbuDesktop|' $out/share/applications/pcbuDesktop.desktop

            wrapQtAppsHook $out/bin/pcbuDesktop 
          '';

          # Metadata 
          meta = with pkgs.lib; {
            description = "The desktop app for PC Bio Unlock. Unlock your PC with your Android phone.";
            license = licenses.gpl3Plus;
            maintainer = "jcray <jakewray@mailbox.org>";
            platforms = platforms.linux;
          };
        };
      }
    );
}
