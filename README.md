# Latex2Typst

A OCaml compiler that translates LaTeX expressions to Typst. It uses Menhir for parsing and Sedlex for lexing.

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

`latex2typst` gives you the option to specify custom LaTeX commands and their Typst equivalents using the `-c` flag. The commands must be provided in a text file, where each line contains a LaTeX command (without the `\`) followed by its Typst equivalent, separated by whitespace. For example:

**custom_latex_commands.txt:**
```
R bb(R)
A cal(A)
```
will map `\R` to `bb(R)` and `\A` to `cal(A)` in the output. You can include as many custom mappings as needed, and they will be applied during the conversion process. One can also specify the number of expected arguments for each command by adding an optional integer at the end of each line.

By default, the program looks for a file named `custom_latex_commands.txt` in the current directory if no custom command file is specified. If this file is not found, the program will proceed without any custom mappings.

## Example
Given the following LaTeX input in `input.tex`:

```latex
\begin{theorem}[\textit{Fundamental Theorem of Calculus \cite{newton}}]
Let $f: [a, b] \to \mathbb{R}$ be a \textbf{continuous} function, and define:
\begin{equation}\label{eq:ftc_integral}
  F(x) = \int_a^x f(t) \dif t \text{The Riemann integral of } $f$ \text{ from } $a$ \text{ to } $x$
\end{equation}
Then $F'(x) = f(x)$ for all $x \in (a, b)$.
\end{theorem}
```
Running the command:

```bash
./latex2typst input.tex
```
will produce the following Typst output:
```typst
#theorem([_Fundamental Theorem of Calculus @newton_], [
Let $f: [a, b] -> RR$ be a *continuous* function, and define:
$<eq:ftc_integral>
  F(x) = integral_a^x f(t) dif t "The Riemann integral of " $f$ " from " $a$ " to " $x$
$
Then $F'(x) = f(x)$ for all $x in (a, b)$.
])
```

## License
This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.