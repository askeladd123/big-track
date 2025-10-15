{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.crane.url = "github:ipetkov/crane";
  outputs = {
    self,
    nixpkgs,
    crane,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    basename = "big-track";
    build = let
      craneLib = crane.mkLib pkgs;
    in
      craneLib.buildPackage {src = craneLib.cleanCargoSource ./.;};
    tests =
      pkgs.writers.writeNuBin "${basename}-tests-nu" {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${pkgs.lib.makeBinPath [build]}"
        ];
      }
      ./tests.nu;
  in {
    devShell.${system} = pkgs.mkShell {
      buildInputs = with pkgs; [cargo rustc rust-analyzer clippy];
      env.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      env.LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [];
    };
    packages.${system}.default = build;
    apps.${system}.tests = {
      type = "app";
      program = "${tests}/bin/${basename}-tests-nu";
    };
    checks.${system}.default = pkgs.stdenvNoCC.mkDerivation {
      name = "${basename}-tests";
      dontBuild = true;
      src = ./.;
      doCheck = true;
      nativeBuildInputs = with pkgs; [nushell];
      checkPhase = ''
        ${tests}/bin/${basename}-tests-nu
      '';
      installPhase = ''
        mkdir $out
      '';
    };
  };
}
