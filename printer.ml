(** Emit Typst from an AST *)

open Ast

let emit_expr buf = function
  | Text s ->
    Buffer.add_string buf s
  | Command c ->
    (match Typst_dict.lookup c with
     | Some typst -> Buffer.add_string buf typst
     | None       -> Buffer.add_string buf c)
  | Cite c ->
    Buffer.add_string buf ("@" ^ c)
  | LBrace ->
    Buffer.add_char buf '('
  | RBrace ->
    Buffer.add_char buf ')'
  | Dollars ->
    Buffer.add_char buf '$'

let emit exprs =
  let buf = Buffer.create 256 in
  List.iter (emit_expr buf) exprs;
  Buffer.contents buf
