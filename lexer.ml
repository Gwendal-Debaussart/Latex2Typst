(** Sedlex-based lexer for LaTeX math expressions *)

open Parser

let token lexbuf =
  match%sedlex lexbuf with
  
  | "\\cite" | "\\citet" | "\\citep" -> CITE

  | "\\ref" | "\\cref" | "\\Cref" | "\\eqref" -> CITE

  | "\\begin" -> BEGIN

  | "\\end" -> END

  | '\\', Plus (Compl ('{' | '}' | '\\' | ' ' | '\t' | '\n' | '\r' | '_' | '^' | ',' | ';' | '.'
                      | '$' | '[' | ']')) ->
    COMMAND (Sedlexing.Utf8.sub_lexeme lexbuf 1 (Sedlexing.lexeme_length lexbuf - 1))

  | '{'          -> LBRACE
  | '}'          -> RBRACE

  | '['          -> LBRACKET
  | ']'          -> RBRACKET

  | "$$"          -> DOLLARS

  | Plus (Compl ('{' | '}' | '[' | ']' | '\\' | '$')) ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)

  | eof -> EOF

  | any ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)

  | _ ->
    TEXT (Sedlexing.Utf8.lexeme lexbuf)
