# fish-spin

Background job spinner for [fish](https://fishshell.com), the friendly interactive
shell.

## Installation

Using [fisher](https://github.com/jorgebucaran/fisher)

```
fisher install jorgebucaran/getopts.fish americanhanko/fish-spin
```

## Dependencies

- Ruby
- Python 3
- `jorgebucaran/getopts.fish`

## Usage

```fish
spin "sleep 1"
```

Spin interprets any output to standard error as failure. Use `--error=FILE` to
redirect the standard error output to a `FILE`.

```fish
if not spin --style=pipe --error=debug.txt "curl -sS $URL"
    return 1
end
```

## Options

```
Usage: spin [OPTIONS]

The following options are available:

    -l or --list            List available spinner sets from sindresorhus
    -s or --spinner=NAME    Name of the spinner set to use from list (default: ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏)
    -c or --chars=CHARS     String of characters that make up the spinner
    -f or --format=FORMAT   Customize the spinner display (default: '  @\r')
    -i or --interval=FLOAT  Number of seconds between frames (default: 240)
    -n or --framesize=SIZE  Number of characters per frame (default: 1)
    -e or --error=FILE      Write errors to FILE (default: /dev/stderr)
    -h or --help            Show usage help
```

## Customization

Replace the default spinner with your own string of characters. For example, `--style=12345`
will display the numbers from 1 to 5, and `--style=.` with `--format=@` an increasing
sequence of dots.


## Troubleshooting

### `XDG_CACHE_HOME not set`

If `XDG_CACHE_HOME` is not, you can set it to a sane value:

```
set -U XDG_CACHE_HOME $HOME/.cache
```
