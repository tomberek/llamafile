#from https://github.com/NixOS/nixpkgs/pull/187509/files
{
  stdenvNoCC,
  lib,
  fetchurl,
  cosmopolitan,
  nixosTests,
}:

stdenvNoCC.mkDerivation {
  pname = "apeloader-bin";
  version = "1.o";

  src =
    if stdenvNoCC.isDarwin then
      fetchurl {
        url = "https://justine.lol/ape.macho";
        hash = "sha256-btvd3YJTsgZojeJJGIrf2OuFDpw9nxmEMleBS5NsWZg=";
      }
    else
      fetchurl {
        url = "https://justine.lol/ape.elf";
        hash = "sha256-fBz4sk4bbdatfaOBcEXVgq2hRrTW7AxqRb6oMOOmX00=";
      };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install $src -D $out/bin/ape
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) apeloader;
  };

  meta = with lib; {
    homepage = "https://justine.lol/apeloader/";
    description = "interpreter for Cosmopolitan C programs";
    inherit (cosmopolitan.meta) license;
    mainProgram = "ape";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = teams.cosmopolitan.members;
    platforms = platforms.unix;
  };
}
