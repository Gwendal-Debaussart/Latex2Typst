(** Abstract Syntax Tree for the LaTeX → Typst converter *)

type expr =
  | Text    of string
  | Command of string
  | Cite    of string
  | LBrace
  | RBrace
  | Dollars
  | Environment of string * string option * expr list
