%{
(* AST types *)
%}

%token <string> TEXT
%token <string> COMMAND
%token LBRACE RBRACE DOLLARS
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
  | CITE LBRACE t = TEXT RBRACE { Ast.Cite t }
