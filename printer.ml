(** Emit Typst from an AST *)

open Ast

let rec emit_expr buf e =
  match e with
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
  | Environment (env, Some name, body) ->
    let env_typst = Printf.sprintf "#%s([%s],[" env name in
    Buffer.add_string buf env_typst;
    List.iter (emit_expr buf) body;
    Buffer.add_string buf "])"
  | Environment ("equation", None, body)
  | Environment ("equation*", None, body)
  | Environment ("align", None, body)
  | Environment ("align*", None, body) ->
    Buffer.add_string buf "$";
    List.iter (emit_expr buf) body;
    Buffer.add_string buf "$"
    | Environment (env, None, body) ->
    let env_typst = Printf.sprintf "#%s(none,[" env in
    Buffer.add_string buf env_typst;
    List.iter (emit_expr buf) body;
    Buffer.add_string buf "])"

let emit exprs =
  let buf = Buffer.create 256 in
  List.iter (emit_expr buf) exprs;
  Buffer.contents buf
