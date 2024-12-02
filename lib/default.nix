{inputs}: _prev: final: {
  forSystems = systems: f:
    final.genAttrs systems (system:
      f (import inputs.nixpkgs {inherit system;}));
  gentooSystem = {
    pkgs,
    system ? "",
    init ? "",
    date ? "",
    flavours ? [""],
  }: let
    flavoursSep = sep: builtins.concatStringsSep sep flavours;
  in
    pkgs.vmTools.runInLinuxVM (pkgs.stdenv.mkDerivation {
      name = "gentoo-${system}-${init}-${flavoursSep "-"}";
      version = date;
      src = pkgs.fetchurl {
        url = "https://builds.xartin.tv/${system}/${init}/${flavoursSep "/"}/gentoo-23.0-${init}-${flavoursSep "-"}-universalcc-${date}-stage4.tar.xz";
        hash = "sha256-FSVCTK1AtBzhIwkxLpFBF9Z4cIcpssD3wA8SeYESa80=";
      };
      memSize = 2048;
      preVM = pkgs.vmTools.createEmptyImage {
        size = 16384;
        fullName = "gentoo-vm";
      };
      unpackPhase = ''
        mkdir /mnt

      '';
    });
}
