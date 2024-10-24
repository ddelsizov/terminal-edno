# Terminal Edno

My first Zig program. Simple implementation of a terminal emulator.

## Features

- Command-line interface with a simple prompt
- Executes system commands using the default shell
- Handles command output and error codes

## Prerequisites

- Zig compiler (developed in Zig 0.13.0)

## Building the Project

1. Clone the repository:
   ```
   git clone https://github.com/ddelsizov/terminal-edno.git
   cd terminal-edno
   ```

2. Build the project:
   ```
   zig build
   ```

## Running the Terminal Emulator

You can run the terminal emulator using:

```
zig build run
```

Or, you can find the executable in the `zig-out/bin`, if you have ran `zig build` and run it directly:

```
./zig-out/bin/terminal-edno
```

## Usage

- Type any system command and press Enter to execute it.
- The command output will be displayed in the terminal.
- Type `history` to view your command history.
- Type `exit` to quit the terminal emulator.

## Limitations and future plans

- Does not support advanced features like auto-completion, complex shell operations, escape sequence handling, input sanitization, and much more.

## License

This project is open source and available under the [MIT License](LICENSE).