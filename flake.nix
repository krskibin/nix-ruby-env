{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs-ruby.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-ruby, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        proj_dir = builtins.getEnv "PROJ_DIR";
        ruby = nixpkgs-ruby.lib.packageFromRubyVersionFile {
          file = "${proj_dir}/.ruby-version";
          inherit system;
        };


        gems = pkgs.bundlerEnv {
          name = "gemset";
          inherit ruby;
          gemfile = "${proj_dir}/Gemfile";
          lockfile = "${proj_dir}/Gemfile.lock";
          gemset = ./gemset.nix;
          groups = [ "default" "production" "development" "test" ];
        };
      in
      {
        devShell = pkgs.mkShell {
            buildInputs = [
              # gems
              ruby
              pkgs.bundix
              pkgs.postgresql
              pkgs.libyaml
              pkgs.pnpm
            ];
          };
      });
}
