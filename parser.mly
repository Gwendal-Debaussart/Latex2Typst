%{
(* AST types *)
%}

%token <string> TEXT
%token <string> FUNC
%token LBRACE RBRACE LBRACKET RBRACKET
%token DOLLARS NEWLINE
%token BEGIN END
%token EOF

%start <Ast.expr list> prog

%%

prog:
  | exprs = list(expr); EOF { exprs }

brace_arg:
  | e = delimited(LBRACE, list(expr), RBRACE) { e }

arg:
  | e = brace_arg { e }
  | e = delimited(LBRACKET, list(expr), RBRACKET) { e }

expr:
  | t = TEXT { Ast.Text t }
  | LBRACKET { Ast.Text "[" }
  | RBRACKET { Ast.Text "]" }
  | DOLLARS { Ast.Text "$" }
  | NEWLINE { Ast.Text "\n" }
  | name = FUNC args = list(brace_arg) { Ast.Func (name, args) }
  | BEGIN LBRACE name=TEXT RBRACE args=list(arg) NEWLINE el=list(expr) END LBRACE TEXT RBRACE { Ast.Env (name, args, el) }
