{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ({ pkgs, ... }: {
          networking.hostName = "semradpi";

          services.openssh.enable = true;
          services.openssh.settings.PermitRootLogin = "yes";
          users.users.root.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBlihWxnAF0W+cuKqpQbN1yOY0bABNhQx7qb1sp83Z1 bjsemrad@gmail.com"
          ];

          hardware.enableRedistributableFirmware = true;
          sdImage.compressImage = false;
          
          services.tailscale.enable = true;

           nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };


          # Ethernet just works. Uncomment for Wi-Fi:
          # networking.wireless.enable = true;
          # networking.wireless.networks."YourSSID".psk = "yourpassword";

          environment.systemPackages = with pkgs; [ vim git ];
          system.stateVersion = "26.05";
        })
      ];
    };
  };
}
