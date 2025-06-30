{ stdenv, lib, dpkg, openssl, libnl, zlib, autoPatchelfHook
, buildFHSEnv, ... }:
let
  pname = "falcon-sensor";
  version = "7.22.0-17507";
  arch = "amd64";
  src = builtins.path { 
    path = ./${pname}_${version}_${arch}.deb;
    name = "${pname}_${version}_${arch}.deb";
  };
  falcon-sensor = stdenv.mkDerivation {
    inherit version arch src;
    name = pname;

    buildInputs = [ dpkg zlib autoPatchelfHook ];

    sourceRoot = ".";

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      cp -r . $out    '';

    meta = with lib; {
      description = "Crowdstrike Falcon Sensor";
      homepage = "https://www.crowdstrike.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ klden ];
    };
  };
in buildFHSEnv {
  name = "fs-bash";
  targetPkgs = pkgs: [ libnl openssl zlib ];

  extraInstallCommands = ''
    ln -s ${falcon-sensor}/* $out/
  '';

  runScript = "bash";
}
