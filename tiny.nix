{ runCommand, inputs, system }:
runCommand "tiny" { } ''
  mkdir -p $out/bin
  cat > $out/bin/tiny <<'EOF'
  #!/bin/sh
  exec "${inputs.self.packages.${system}.apeloader}/bin/ape" "${inputs.tiny.outPath}" \
   -e \
   -p "The following is a conversation between a Researcher and their helpful AI
   Assistant which is a large language model trained on the
   sum of human knowledge.
   Researcher: Good morning.
   Assistant: How can I help you today?
   Researcher: $@\n" \
   --log-disable \
   --interactive --batch_size 1024 --ctx_size 4096 \
   --keep -1 --temp 0 --mirostat 2 --in-prefix ' ' \
   --in-suffix 'Assistant:' --reverse-prompt 'Researcher:'
  EOF
  chmod +x $out/bin/tiny
''
