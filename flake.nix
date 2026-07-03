{
  description = "BoilR (custom build)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.boilr = pkgs.boilr.overrideAttrs (old: {
        src = ./.;                # your local, modified checkout
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = ./Cargo.lock;
        };
        # bump this if you change dependency versions in Cargo.toml
      });

      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.boilr ];
        packages = [ pkgs.cargo pkgs.rustc pkgs.rust-analyzer ];
      };
    };
}
