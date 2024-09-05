{
  description = "Suspend sleep";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        fs = pkgs.lib.fileset;

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

        sourceFiles = ./meson.build;
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "caffeinated";
            src = ./.;

            meta = with pkgs.lib; {
              description = "caffeinated";
            };

            inherit nativeBuildInputs buildInputs;
          };
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; nativeBuildInputs ++ buildInputs;
          };
        };
      });
}
