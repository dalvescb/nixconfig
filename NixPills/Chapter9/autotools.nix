pkgs: attrs:
  with pkgs;
  let defaultAttrs = {
      builder = "${bash}/bin/bash";
      args = [ ./builder.sh ];
      baseInputs = [ patchelf findutils gnutar gzip gnumake gcc binutils-unwrapped coreutils gawk gnused gnugrep ];
      buildInputs = [];
      system = builtins.currentSystem;
    };
  in
  derivation (defaultAttrs // attrs)
