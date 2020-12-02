{ nativePkgs ? (import ./default.nix {}).pkgs,
crossBuildProject ? import ./cross-build.nix {} }:
nativePkgs.lib.mapAttrs (_: prj:
with prj.was-supervision;
let
  executable = was-supervision.components.exes.was-supervision;
  binOnly = pkgs.runCommand "was-supervision-bin" { } ''
    mkdir -p $out/bin
    cp ${executable}/bin/was-supervision $out/bin
    ${nativePkgs.nukeReferences}/bin/nuke-refs $out/bin/was-supervision
  '';
in pkgs.dockerTools.buildImage {
  name = "was-supervision";
  contents = [ binOnly pkgs.cacert pkgs.iana-etc ];
  config.Entrypoint = "was-supervision";
}) crossBuildProject
