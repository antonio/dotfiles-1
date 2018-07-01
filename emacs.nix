{ pkgs, ...}:

let
  emacs27 = pkgs.stdenv.lib.overrideDerivation pkgs.emacs (oldAttrs : {
    version = "27.0-2018-06-18";
    src = pkgs.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "3e2215642bbca3d1335155278eace39d0a87c267";
      sha256 = "1g8dqk1vnca40zav0dz9msjinny70z9y1mkrwjnl6kq0l76s026j";
    };
    withGTK3 = true;
    withGTK2 = false;
    patches = [];
  });
  emacs = emacs27;
in
{
  environment.systemPackages = [
      emacs
  ];

  services.emacs.package = emacs;
  services.emacs.enable = true;
}
