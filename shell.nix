{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    chuck
    audacity
    # miniaudicle
    # rustc
    # cargo
    # gcc
    # rustfmt
    # clippy
    # rustPlatform.bindgenHook # required for libparted, sets LIBCLANG_PATH and friends
    # rustPlatform.cargoSetupHook
    # rustlings
  ];

  # Certain Rust tools won't work without this
  # This can also be fixed by using oxalica/rust-overlay and specifying the rust-src extension
  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela. for more details.
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
