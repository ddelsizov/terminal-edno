# Terminal Edno

A simple, terminal emulator implemented in Zig.

If you know about "Terminal edno" as a phrase in the bulgarian language, and why its used, you get 10 bonus points. :D

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

After building, you can run the terminal emulator using:

```
zig build run
```

Or, you can find the executable in the `zig-out/bin` directory and run it directly:

```
./zig-out/bin/terminal-edno
```

## Usage

- Type any system command and press Enter to execute it.
- The command output will be displayed in the terminal.
- Type `exit` to quit the terminal emulator.

## Project Structure

- `src/main.zig`: The main source file containing the terminal emulator logic
- `build.zig`: The build script for the project

## Limitations and future plans

- This is a very very basic implementation, as i learn about Zig and does not support advanced features like auto-completion, complex shell operations, escape sequence handling, and much more which is usually expected.

## License

This project is open source and available under the [MIT License](LICENSE).