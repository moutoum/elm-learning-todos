# HTTP server

This sub-project is a simple HTTP server written in Rust to handle interactions and manage
the todos.

The goal is to manage the HTTP request to manage a store from the Elm front-end.

## Installation

In first, be sure the rust nightly toolchain is available in your environment.

Then, you can build the server using this command:

```shell script
cargo build --release
```

## Run

Just start the newly created binary. You can communicate with the server
at `locahost:8000` by default. 

```shell script
./target/release/server
```