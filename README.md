# Latex2Typst

A simple OCaml compiler that translates mathematical expressions from LaTeX to Typst. It uses Menhir for parsing and Sedlex for lexing.

## Building

Install OCaml, Dune, Menhir, and Sedlex. Then run:

```bash
dune build
```

The executable will be located at `_build/default/latex2typst.exe`.

Several executables are already available in the [Releases]() page.

## Usage

```bash
./latex2typst input_file [-c custom_latex_commands]
```

latex2typst gives you the option to specify custom LaTeX commands and their Typst equivalents using the `-c` flag. The commands must be provided in a text file, where each line contains a LaTeX command (without the `\`) followed by its Typst equivalent, separated by whitespace. For example:

**custom_commands.txt:**
```
R bb(R)
A cal(A)
```
will map `\R` to `bb(R)` and `\A` to `cal(A)` in the output. You can include as many custom mappings as needed, and they will be applied during the conversion process.

By default, the program looks for a file named `custom_latex_commands.txt` in the current directory if no custom command file is specified. If this file is not found, the program will proceed without any custom mappings.

```bash
./latex2typst input_file [-c custom_commands.txt]
```

## Example
Given the following LaTeX input in `input.tex`:

```latex
$$
\forall x \in \Omega, k(\cdot, x) \in \mathcal{S}(\mu) \cap \mathcal{S}(\pi)
$$
```
Running the command:

```bash
./latex2typst input.tex
```
will produce the following Typst output:
```typst
$
forall x in Omega, k(dot, x) in cal(S)(mu) inter cal(S)(pi)
$
```

## License
This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.