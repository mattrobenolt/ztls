{ pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.download-buffer-size = 134217728;

  # Disable ASLR for stable benchmark addresses and fewer page-table variations.
  boot.kernel.sysctl."kernel.randomize_va_space" = 0;

  # Mask services not needed during benchmarking to reduce timer interrupts
  # and background CPU noise.
  systemd.services.amazon-ssm-agent.enable = false;
  systemd.services.systemd-timesyncd.enable = false;
  systemd.services.systemd-oomd.enable = false;
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services.dhcpcd.enable = false;

  environment.systemPackages = with pkgs; [
    git
    rsync
    tmux
    htop
  ];
}
