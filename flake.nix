{
  inputs.tiny.url = "https://huggingface.co/jartine/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/TinyLlama-1.1B-Chat-v1.0.Q5_K_M.llamafile";
  inputs.tiny.flake = false;

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      apeloader = pkgs.callPackage ({ stdenvNoCC, lib, fetchurl, cosmopolitan, nixosTests }:

stdenvNoCC.mkDerivation {
  pname = "apeloader-bin";
  version = "1.o";

  src =
    if stdenvNoCC.isDarwin
    then
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
}) {};

      tiny = pkgs.runCommand "tiny" {} ''
        mkdir -p $out/bin
        cat > $out/bin/tiny <<'EOF'
        #!/bin/sh
        exec "${inputs.self.packages.${system}.apeloader}/bin/ape" "${inputs.tiny.outPath}" \
         -p "The following is a conversation between a Researcher and their helpful AI
         Assistant which is a large language model trained on the
         sum of human knowledge.
         Researcher: Good morning.
         Assistant: How can I help you today?
         Researcher: $@" \
         --silent-prompt \
         --no-display-prompt \
         --log-disable \
         --interactive --batch_size 1024 --ctx_size 4096 \
         --keep -1 --temp 0 --mirostat 2 --in-prefix ' ' \
         --in-suffix 'Assistant:' --reverse-prompt 'Researcher:'
        EOF
        chmod +x $out/bin/tiny
        '';
    }) inputs.nixpkgs.legacyPackages;
  };
}
