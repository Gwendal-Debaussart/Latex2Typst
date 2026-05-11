(** Emit Typst from an AST *)

open Ast

let concat_list_list (ll : string list list) : string list =
  List.map (fun l -> String.concat "" l) ll

let emit_expr debug e =
  let rec aux e =
    match e with
    | Text s ->
      if debug then
        Printf.printf "Emitting text \"%s\"\n" s;
      s
    | Func (("cite" | "citet" | "citep" | "ref" | "cref" | "Cref" | "eqref"), [[ref]]) ->
      let ref_str = aux ref in
      if debug then
        Printf.printf "Emitting citation \"%s\"\n" ref_str;
      "@" ^ ref_str
    | Func ("frac", args) ->
      let str_args = concat_list_list (List.map (fun l -> List.map aux l) args) in
      let (num_str, den_str) = match str_args with
       | num_str :: den_str :: _ -> (num_str, den_str)
       | _ -> failwith "Error: \\frac requires two arguments"
      in
      if debug then
        Printf.printf "Emitting fraction with numerator \"%s\" and denominator \"%s\"\n"
          num_str den_str;
      "(" ^ num_str ^ ") / (" ^ den_str ^ ")"
    | Func ("label", [[label]]) ->
      let label_str = aux label in
      if debug then
        Printf.printf "Emitting label \"%s\"\n" label_str;
      "<" ^ label_str ^ ">"
    | Func ("mathbb", [[arg]]) ->
      let arg_str = aux arg in
      if debug then
        Printf.printf "Emitting mathbb with argument \"%s\"\n" arg_str;
      if String.length arg_str = 1 then
        arg_str^arg_str
      else
        "mathbb(" ^ arg_str ^ ")"
    | Func (name, l_args) ->
      let name = match Typst_dict.lookup name with
        | Some t -> t
        | None -> name
      in
      (match l_args with
      | [] ->
        if debug then
          Printf.printf "Emitting func \"%s\"\n" name;
        name
      | args ->
        let str_args = concat_list_list (List.map (fun l -> List.map aux l) args) in
        let args_str = String.concat ", " str_args in
        if debug then
          Printf.printf "Emitting func \"%s\" with args \"%s\"\n" name args_str;
        name ^ "(" ^ args_str ^ ")")
    | Env (("equation" | "equation*" | "align" | "align*"), [], content) ->
      let content_str = String.concat "" (List.map aux content) in
      if debug then
        Printf.printf "Emitting math environment with content \"%s\"\n" content_str;
      "$" ^ content_str ^ "$"
    | Env (name, args, content) ->
      let content_str = String.concat "" (List.map aux content) in
      (match args with
      | [] ->
        if debug then
          Printf.printf "Emitting environment \"%s\"\n" name;
        "#" ^ name ^ "([" ^ content_str ^ "])"
      | args ->
        let str_args = concat_list_list (List.map (fun l -> List.map aux l) args) in
        let args_str = String.concat ", " (List.map (fun arg -> "[" ^ arg ^ "]") str_args) in
        if debug then
          Printf.printf "Emitting environment \"%s\" with args \"%s\"\n" name args_str;
        "#" ^ name ^ "(" ^ args_str ^ ", " ^ "[" ^ content_str ^ "])")
  in
  aux e

let emit debug exprs =
  List.fold_left (fun acc e -> acc ^ emit_expr debug e) "" exprs
