{
  description = "Nix Flake for IntegratedLearner R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        IntegratedLearner = pkgs.rPackages.buildRPackage {
          name = "IntegratedLearner";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              bartMachine
              caret
              cowplot
              glmnetUtils
              mcmcplots
              nloptr
              quadprog
              ROCR
              SuperLearner
              tidyverse
              ;
          };
        };
      in
      {
        packages.default = IntegratedLearner;
        devShells.default = pkgs.mkShell {
          buildInputs = [ IntegratedLearner ];
          inputsFrom = pkgs.lib.singleton IntegratedLearner;
        };
      }
    );
}
