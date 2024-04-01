{
  inputs.tiny.url = "https://huggingface.co/jartine/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/TinyLlama-1.1B-Chat-v1.0.Q5_K_M.llamafile";
  inputs.tiny.flake = false;

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      apeloader = pkgs.callPackage ./apeloader-bin.nix {};
      tiny = pkgs.callPackage ./tiny.nix {inherit inputs system;};
    }) inputs.nixpkgs.legacyPackages;
  };
}
