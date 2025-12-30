{ lib, config, pkgs, ... }:

with lib;
with lib.my;
mkIf (elem "wg0" config.modules.profiles.networks) (mkMerge [{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.enable = true;

  # Enable IP forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };
  
networking.wg-quick.interfaces.wg0 = {
  address = [ "10.100.0.1/24" ];
  listenPort = 51820;
  privateKeyFile = "/etc/wireguard/privatekey";
  
  peers = [
    {
      publicKey = "yCM2pBaEJ1MHFRJAe40Ih9fWhlaXU8oNOIrSj/Cv1y8=";
      allowedIPs = [ "10.100.0.2/32" ];
    }
    {
      publicKey = "cTGGfXd9GEiREulMlYX20qW2HJ4GaLmbr1Bl1FFzyQI=";
      allowedIPs = [ "10.100.0.3/32" ];
    }
  ];
  
  # Let wg-quick handle routing automatically
  # postUp = "iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE";
  # postDown = "iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE";

  # Add NAT + DNAT for LAN router
  postUp = ''
    # Masquerade all VPN traffic going out to the LAN
    iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE

    # Forward 10.100.0.254 to the LAN router (192.168.8.1)
    iptables -t nat -A PREROUTING -i wg0 -d 10.100.0.254 -j DNAT --to-destination 192.168.8.1
    iptables -t nat -A POSTROUTING -o wlp4s0 -d 192.168.8.1 -j MASQUERADE
  '';

  postDown = ''
    iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE

    iptables -t nat -D PREROUTING -i wg0 -d 10.100.0.254 -j DNAT --to-destination 192.168.8.1
    iptables -t nat -D POSTROUTING -o wlp4s0 -d 192.168.8.1 -j MASQUERADE
  '';
};

  # Generate keys declaratively
  system.activationScripts.wireguardKeys.text = ''
    mkdir -p /etc/wireguard
    umask 077
    # Generate server key only if missing
    if [ ! -f /etc/wireguard/privatekey ]; then
      ${pkgs.wireguard-tools}/bin/wg genkey > /etc/wireguard/privatekey
      ${pkgs.wireguard-tools}/bin/wg pubkey < /etc/wireguard/privatekey > /etc/wireguard/publickey
    fi
  '';
}])
