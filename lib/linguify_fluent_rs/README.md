# Rust Fluent WebAssembly

Basic functionalities.

Code in `wasm-macro` is partly from [here](https://github.com/astrale-sharp/wasm-minimal-protocol)

## Usage

generate the wasm file by running

```bash
rustup target add wasm32-unknown-unknown
cargo build --release --target wasm32-unknown-unknown
cp target/wasm32-unknown-unknown/release/linguify_fluent_rs.wasm .
```
