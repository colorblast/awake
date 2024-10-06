{
  description = "awake is a native stay-awake system tray indicator for pantheon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        nativeBuildInputs = with pkgs; [
          meson
          ninja
          vala
          pkg-config
        ];

        buildInputs = with pkgs; [
          pantheon.granite
          gtk3
          libgee
          pantheon.wingpanel
        ];
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "awake";
            src = self;

            meta = {
              description = "awake is a native stay-awake system tray indicator for pantheon ";
            };

            inherit nativeBuildInputs buildInputs;
          };
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; nativeBuildInputs ++ buildInputs ++ [ uncrustify bashInteractive ];
          };
        };
      });
}
