%{
(* AST types *)
%}

%token <string> TEXT
%token <string> FUNC
%token LBRACE RBRACE LBRACKET RBRACKET
%token DOLLARS NEWLINE
%token BEGIN END
%token UNDERSCORE CARET
%token EOF

%start <Ast.expr list> prog

%%

prog:
  | exprs = list(expr); EOF { exprs }

brace_arg:
  | e = delimited(LBRACE, nonempty_list(expr_no_br), RBRACE) { e }

arg:
  | arg = brace_arg { arg }
  | e = delimited(LBRACKET, nonempty_list(expr_no_br), RBRACKET) { e }

env:
  | BEGIN LBRACE name=TEXT RBRACE args=list(arg)
    el=nonempty_list(expr)
    END LBRACE TEXT RBRACE { Ast.Env (name, args, el) }

expr_no_br:
  | t = TEXT { Ast.Text t }
  | DOLLARS { Ast.Text "$" }
  | NEWLINE { Ast.Text "\n" }
  | UNDERSCORE arg = option(delimited(LBRACE, list(expr), RBRACE))
    { Ast.Subscript (Option.value arg ~default:[]) }
  | CARET arg = option(delimited(LBRACE, list(expr), RBRACE))
    { Ast.Superscript (Option.value arg ~default:[]) }
  | name = FUNC args = list(arg) { Ast.Func (name, args) }
  | env=env { env }

expr:
  | e=expr_no_br { e }
  | LBRACKET { Ast.Text "[" }
  | RBRACKET { Ast.Text "]" }