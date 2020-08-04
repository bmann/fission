let
  sources  = import ./nix/sources.nix;
  pkgs     = import sources.nixpkgs  {};
  unstable = import sources.unstable {};
in

pkgs.mkShell {
  buildInputs = [
    pkgs.curl
    pkgs.gnumake
    pkgs.zlib

    # Data
    # pkgs.ipfs
    pkgs.libpqxx
    pkgs.postgresql

    # Haskell
    unstable.ghcid
    unstable.stack
    unstable.stylish-haskell
  ];
}
