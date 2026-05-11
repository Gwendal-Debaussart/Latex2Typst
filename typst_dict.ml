let builtin : (string, string) Hashtbl.t = Hashtbl.create 64

let () =
  List.iter (fun (k, v) -> Hashtbl.add builtin k v)
  [
    "int", "integral";
    "to", "->";
    "gets", "<-";
    "infty", "oo";
    "mapsto", "|->";
    "leq", "<=";
    "geq", ">=";
    "neq", "!=";
    "iff", "<==>";
    "implies", "=>";
    "impliedby", "<=";
    "sim", "tilde";
    "propto", "prop";
    "subseteq", "subset.eq";
    "mathcal", "cal";
    "mathbb", "bb";
    "mathfrak", "frak";
    "mathbf", "bold";
    "cdot", "dot";
    "ldots", "...";
    "cdots", "dots.h.c";
    "vdots", "dots.v";
    "ddots", "dots.down";
    "iddots", "dots.up";
    "cap", "inter";
    "cup", "union";
    "notin", "in.not";
    "ni", "in.rev";
    "lVert", "||";
    "rVert", "||";
    "ll", "<<";
    "gg", ">>";
    "middle", "mid";
    "land", "and";
    "lor", "or";
    "circ", "compose";
    "hfill", "#h(1fr)";
    "vfill", "#v(1fr)";
    "blacksquare", "qed";
    "N", "NN";
    "Z", "ZZ";
    "R", "RR";
    "C", "CC";
    "Q", "QQ";
    "left", "";
    "right", "";
    "Big", "";
  ]

let custom : (string, string) Hashtbl.t = Hashtbl.create 16

let load_custom path =
  let ic = open_in path in
  (try
    while true do
      let line = String.trim (input_line ic) in
      if line <> "" && line.[0] <> '#' then
        match String.split_on_char ' ' line
              |> List.filter (fun s -> s <> "") with
        | latex :: typst :: _ -> Hashtbl.replace custom latex typst
        | _ ->
          Printf.eprintf "Warning: ignoring malformed line in custom file: %s\n" line
    done
  with End_of_file -> ());
  close_in ic

let default_custom_file = "custom_latex_commands.txt"

let lookup cmd =
  match Hashtbl.find_opt custom cmd with
  | Some _ as r -> r
  | None        -> Hashtbl.find_opt builtin cmd

