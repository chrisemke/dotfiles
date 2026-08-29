(define-module (dev rust-dev)
  #:use-module ((guix profiles)
                #:select (packages->manifest))
  #:use-module ((gnu packages base)
                #:select (coreutils grep which))
  #:use-module ((gnu packages bash)
                #:select (bash))
  #:use-module ((gnu packages commencement)
                #:select (gcc-toolchain))
  #:use-module ((gnu packages compression)
                #:select (zlib))
  #:use-module ((gnu packages curl)
                #:select (curl))
  #:use-module ((gnu packages nss)
                #:select (nss-certs))
  #:use-module ((gnu packages pkg-config)
                #:select (pkg-config))
  #:use-module ((gnu packages protobuf)
                #:select (protobuf))
  #:use-module ((gnu packages python-xyz)
                #:select (python-rassumfrassum))
  #:use-module ((gnu packages version-control)
                #:select (git)))

(packages->manifest
 (list
  ;; base
  bash
  coreutils
  grep
  which
  ;; network and TLS: the rustup installer, cargo, git
  curl
  git
  nss-certs
  ;; linking: rustup ships no linker, and every *-sys crate needs one
  gcc-toolchain
  pkg-config
  zlib
  ;; gRPC: tonic-build and prost-build shell out to protoc
  protobuf
  ;; Connect an LSP client to multiple LSP servers.
  python-rassumfrassum))
