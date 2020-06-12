{
  network.destination = "NixKube";

  master =
    { config, pkgs, ... }:
    {
      imports = [
        ./configuration.nix
      ];

      networking.hostName = "nixkube-01";
      networking.extraHosts = ''
        192.168.1.72 nixkube-01
        192.168.1.73 nixkube-02
      '';
      
      environment.systemPackages = with pkgs; [
        kompose
        kubectl
        kubernetes
      ];

      services.kubernetes = {
        roles = ["master" "node"];
        masterAddress = "nixkube-01";
        easyCerts = true;
        apiserver = {
          securePort = 443;
          advertiseAddress = "192.168.1.72";
        };

        addons.dns.enable = true;
        addons.dashboard = {
          enable = true;
        };

        kubelet.extraOpts = "--fail-swap-on=false";
      };
    };

  node =
    { config, pkgs, ... }:
    {
      imports = [
        ./configuration.nix
      ];

      networking.hostName = "nixkube-02";
      networking.extraHosts = ''
        192.168.1.72 nixkube-01
        192.168.1.73 nixkube-02
      '';
      
      environment.systemPackages = with pkgs; [
        kompose
        kubectl
        kubernetes
      ];

     services.kubernetes = let
       api = "https://nixkube-01:443";
     in {
       roles = ["node"];
       masterAddress = "nixkube-01";
       easyCerts = true;

       kubelet.kubeconfig.server = api;
       apiserverAddress = api;

       addons.dns.enable = true;        
        
       kubelet.extraOpts = "--fail-swap-on=false";
     };
    };    
}
