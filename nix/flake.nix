{
  description = "aleks nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self
    , nix-darwin
    , nixpkgs
    , mac-app-util
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , home-manager
  }:
  let
    configuration = { pkgs, config, ... }: {
      # Necessary for determinate-nix
      # see https://determinate.systems/posts/nix-darwin-updates/
      nix.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # allow installing non open source apps
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        with pkgs; [
          alacritty
          bat
          colima
          discord
          docker
          eza
          flyctl
          fzf
          git
          go
          gradle
          jq
          kubectl
          neovim
          ripgrep
          vim
          zoxide
        ];
      fonts.packages =
        with pkgs; [
          nerd-fonts.sauce-code-pro
        ];

      homebrew = {
        enable = true;
        casks = [ "firefox" ];
        brews = [ "mas" ];

        masApps = {
          "bitwarden" = 1352778147;
        };
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      power.sleep.display = 2;
      power.sleep.computer = 5;
      power.sleep.harddisk = 2;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      system.defaults = {
        alf = {
          allowdownloadsignedenabled = 1;
          allowsignedenabled = 1;
          globalstate = 1;
        };

        controlcenter.BatteryShowPercentage = true;

        dock.autohide = true;

        finder.FXPreferredViewStyle = "clmv";

        loginwindow.GuestEnabled = false;

        magicmouse.MouseButtonMode = "TwoButton";

        menuExtraClock.Show24Hour = true;
        menuExtraClock.ShowDate = 0;
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      users = {
        users = {
          aleks = {
            home = /Users/aleks;
            shell = pkgs.zsh;
          };
        };
      };
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbookpro
    darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
      modules = [
         configuration
         mac-app-util.darwinModules.default

         nix-homebrew.darwinModules.nix-homebrew
         {
           nix-homebrew = {
             # Install Homebrew under the default prefix
             enable = true;

             # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
             enableRosetta = true;

             # User owning the Homebrew prefix
             user = "aleks";

             # Optional: Declarative tap management
             taps = {
               "homebrew/homebrew-core" = homebrew-core;
               "homebrew/homebrew-cask" = homebrew-cask;
             };

             # Optional: Enable fully-declarative tap management
             #
             # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
             mutableTaps = false;
           };
         }

         home-manager.darwinModules.home-manager
         {
           home-manager = {
             useGlobalPkgs = true;
             useUserPackages = true;
             users = {
                aleks = import ./home-manager/flake.nix;
             };
          };

           # Optionally, use home-manager.extraSpecialArgs to pass
           # arguments to home.nix
         }
      ];
    };
  };
}
