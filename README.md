# fish-spin

Background job spinner for the [fish shell](https://fishshell.com).

## Installation

With [Fisher](https://github.com/jorgebucaran/fisher)

```
fisher add fishpkg/fish-spin
```

## Usage

```fish
spin "sleep 1"
```

Spin interprets any output to standard error as failure. Use `--error=FILE` to redirect the standard error output to a `FILE`.

```fish
if not spin --style=pipe --error=debug.txt "curl -sS $URL"
    return 1
end
```

## Options

- `-s` or `--style=STRING`: Use `STRING` to slice the spinner characters. If you don't want to display the spinners, use `--style=""`.

- `-f` or `--format=FORMAT`: Use `FORMAT` to customize the spinner display. The default format is `" @\r"` where `@` represents the spinner token and `\r` a carriage return, used to refresh (erase) the line.

- `--error=FILE`: Write the standard error output to the specified FILE.

- `-h` or `--help`: Show usage help.

### Customization

Replace the default spinner with your own string of characters. For example, `--style=12345` will display the numbers from 1 to 5, and `--style=.` with `--format=@` an increasing sequence of dots.

## License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
