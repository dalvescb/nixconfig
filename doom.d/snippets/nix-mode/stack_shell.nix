# -*- mode: snippet -*-
# name: stack_shell.nix
# key: s_stack_shell.nix
# --
with import (builtins.fetchTarball {
  name = "nixpkgs-unstable-2021-09-06";
  url = "https://github.com/NixOS/nixpkgs/archive/efcfe3676268c789e78a22b20a94c00227d20bc8.tar.gz";
  sha256 = "0qdxgwk4bqy16vxbb43n0245bdisf1l329ax6gd96576l0ya690s";
  }) {};

haskell.lib.buildStackProject {
  name = "${1:project-name}";
  buildInputs = [ haskell.compiler.ghc8107
                  ghcid
                  cabal-install
                  haskellPackages.ormolu
                  haskellPackages.hoogle
                  (haskell-language-server.override { supportedGhcVersions = [ "8107" ]; })
                  ];
  }

# To use this add the following to the bottom of your stack.yaml
# nix:
#   enable: true
#   shell-file: shell.nix

# also execute the following in the project root
# echo "use nix" >> .envrc
# direnv allow