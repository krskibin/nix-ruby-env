# nix-ruby-env
> Flexible Ruby Development Environment based on Nix Flakes

nix-ruby-env provides a flexible and containerized environment for Ruby development, allowing you
to use any Ruby version, even those not yet available in Nixpkgs. It adheres to the principles of NixOS,
ensuring reproducibility and consistency. The environment is ready to use—just install
PostgreSQL and Redis, and you're good to go.

#### nix-ruby-env uses [nixpkgs-ruby](https://github.com/bobvanderlinden/nixpkgs-ruby)

## Usage
nix-ruby-env is designed to work seamlessly with `direnv` just follow those few quick steps

1. [Optional] Add to your global `.gitignore` or project one - `.envrc` file.
2. Create `.envrc file`

Example:
```
watch_file .ruby-version

export PROJ_DIR="$HOME/project_name/"

use flake ../nix-ruby-env --impure
```
3. Download the repository and put its path to `.envrc`
4. In your project directory type `direnv allow`
5. Run `bundix` command and copy output to the `nix-ruby-env` directory
```bash
mv gemset.nix ../nix-ruby-env
```
6. Edit flake files to add **redis** and **database** configurations

### Redis configuration
Example Redis configuration:
```nix
{
  services.redis.servers."".enable = true;
  services.redis.servers."".port = 6379;
}
```
### Postgresql config
```
{
  config.services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local   all      all                     trust
      host    all      all     127.0.0.1/32    trust
      host    all      all     ::1/128         trust
    '';

    identMap = ''
       superuser_map      root      postgres
       superuser_map      postgres  postgres
       superuser_map      /^(.*)$   \1
    '';

    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE <username> WITH CREATEDB CREATEROLE LOGIN SUPERUSER;
    '';
  };
}
```

## Credits
Thanks to **bobvanderliden** for creating this [repository](https://github.com/bobvanderlinden/nixpkgs-ruby). Your work has 
saved me a lot of time, and truly appreciate the effort you put into 
making this tool available.

