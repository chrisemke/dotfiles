(specifications->manifest
 (list
  ;; base
  "bash" "coreutils" "grep" "which"
  ;; network and TLS: the rustup installer, cargo, git
  "curl" "git" "nss-certs"
  ;; linking: rustup ships no linker, and every *-sys crate needs one
  "gcc-toolchain" "pkg-config" "zlib"
  ;; gRPC: tonic-build and prost-build shell out to protoc
  "protobuf"
  ;; Connect an LSP client to multiple LSP servers.
  "python-rassumfrassum"))
