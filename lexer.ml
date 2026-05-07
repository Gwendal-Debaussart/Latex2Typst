(** Sedlex-based lexer for LaTeX math expressions *)

open Parser

let token lexbuf =
  match%sedlex lexbuf with
  
  | "\\cite" | "\\citet" | "\\citep" -> CITE

  | '\\', Plus (Compl ('{' | '}' | '\\' | ' ' | '\t' | '\n' | '\r' | '_' | '^' | ',' | ';' | '.'
                      | '$')) ->
    COMMAND (Sedlexing.Utf8.sub_lexeme lexbuf 1 (Sedlexing.lexeme_length lexbuf - 1))

  | '{'          -> LBRACE
  | '}'          -> RBRACE

  | "$$"          -> DOLLARS

  | Plus (Compl ('{' | '}' | '\\' | '$')) ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)

  | eof -> EOF

  | any ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)

  | _ ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)
