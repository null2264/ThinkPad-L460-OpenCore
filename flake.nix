{
  description = "null2264's ThinkPad L460 OpenCore Hackintosh";

  outputs = { self, nixpkgs, utils, oceanix, ... }:
    utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      {
        packages = rec {
          thinkpad-l460 = (oceanix.lib.OpenCoreConfig {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ oceanix.overlays.default ];
            };

            modules = [
              ./nix/modules
            ];
          }).efiPackage;
          default = thinkpad-l460;
        };
      });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";

    utils.url = "github:numtide/flake-utils";

    oceanix = {
      url = "github:null2264/oceanix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };
}
