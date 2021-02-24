# fish-spin

Background job spinner for [fish](https://fishshell.com), the friendly interactive
shell.

## Installation

Using [fisher](https://github.com/jorgebucaran/fisher)

```
fisher install jorgebucaran/getopts.fish americanhanko/fish-spin
```

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
Usage: spin COMMANDS [(-s | --style STYLE)] [(-f | --format FORMAT)]
                     [(-i | --rate FLOAT)] [--error FILE] [(-h | --help)]

    -c --chars STRING   Inline string to use as the spinner characters.
    -f --format FORMAT  Customize the spinner display (default: '  @\r')
    -r --rate FLOAT Determine the rate between slices (default: 240)
    -n --size INT   Set the size of the spinner frames (default: 1)
    -s --set STRING Name of the spinner set to use (default: )
    -e --error FILE     Write errors to FILE (default: /dev/stderr)

    -s --list       List available spinner sets
    -h --help       Show usage help
```

## Customization

Replace the default spinner with your own string of characters. For example, `--style=12345`
will display the numbers from 1 to 5, and `--style=.` with `--format=@` an increasing
sequence of dots.


## Troubleshooting

### `XDG_CACHE_HOME not set`

If `XDG_CACHE_HOME` is not, you can set it a sane value:

```
set -U XDG_CACHE_HOME $HOME/.cache
```
