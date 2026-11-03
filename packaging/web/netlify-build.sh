#!/usr/bin/env bash
set -euo pipefail

# Netlify provides rustup and cargo, but no default Rust toolchain.
rustup toolchain install 1.97.0 --profile minimal --target wasm32-unknown-unknown

trunk_root="${NETLIFY_CACHE_DIR:-/tmp}/anything-studio-trunk"
if [ ! -x "$trunk_root/bin/trunk" ]; then
  cargo install --locked --version 0.22.1 trunk --root "$trunk_root"
fi

(
  cd apps/craft-anything-web
  "$trunk_root/bin/trunk" build --release
)

cp packaging/web/_headers dist/web/_headers
test -s dist/web/index.html
test -n "$(find dist/web -maxdepth 1 -name '*.wasm' -print -quit)"
