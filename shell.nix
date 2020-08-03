let
  sources = import ./nix/sources.nix;
  pkgs    = import sources.nixpkgs {};
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
    pkgs.ghcid
    pkgs.stack
    pkgs.stylish-haskell
  ];
}
