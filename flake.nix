{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib.extend (import ./lib {inherit inputs;});
    systems = ["x86_64-linux"];
  in {
    inherit lib;
    packages = self.lib.forSystems systems (pkgs: {
      gentoo = self.lib.gentooSystem {
        inherit pkgs;
        system = "amd64";
        init = "openrc";
        flavours = ["desktop"];
        date = "2024-10-08_10-01";
      };
    });
  };
}
