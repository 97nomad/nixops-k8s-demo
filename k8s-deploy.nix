{
  master =
    { config, pkgs, ... }:
    {
      deployment.targetHost = "192.168.1.72";
    };

  node =
    { config, pkgs, ...}:
    {
      deployment.targetHost = "192.168.1.73";
    };
}
