%{
(* AST types *)
%}

%token <string> TEXT
%token <string> COMMAND
%token LBRACE RBRACE LBRACKET RBRACKET NEWLINE
%token DOLLARS
%token BEGIN END
%token CITE
%token EOF

%start <Ast.expr list> prog

%%

prog:
  | exprs = list(expr); EOF { exprs }

expr:
  | t = TEXT    { Ast.Text t }
  | c = COMMAND { Ast.Command c }
  | DOLLARS     { Ast.Dollars }
  | LBRACE      { Ast.LBrace }
  | RBRACE      { Ast.RBrace }
  | LBRACKET    { Ast.Text "[" }
  | RBRACKET    { Ast.Text "]" }
  | NEWLINE     { Ast.Text "\\" }
  | CITE LBRACE t = TEXT RBRACE { Ast.Cite t }
  | BEGIN LBRACE t = TEXT RBRACE
    name = option(delimited(LBRACKET, TEXT, RBRACKET))
    body = list(expr) END LBRACE TEXT RBRACE
      { Ast.Environment (t, name, body) }
