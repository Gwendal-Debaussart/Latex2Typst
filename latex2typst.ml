(** typst2latex – entry point *)

let usage = {|
Usage: typst2latex [OPTIONS] <file.tex>

Options:
  -c <path>   Use a custom command mapping file (default: "custom_commands")
  -h          Show this help message
|}

let () =
  let custom_file = ref None in
  let input_file  = ref None in

  let rec parse = function
    | [] -> ()
    | "-h" :: _ ->
      print_string usage; exit 0
    | "-c" :: path :: rest ->
      custom_file := Some path;
      parse rest
    | "-c" :: [] ->
      Printf.eprintf "Error: -c requires a file path argument\n%s" usage;
      exit 1
    | arg :: _ when String.length arg > 0 && arg.[0] = '-' ->
      Printf.eprintf "Unknown option: %s\n%s" arg usage;
      exit 1
    | path :: rest ->
      (match !input_file with
       | None   -> input_file := Some path
       | Some _ -> Printf.eprintf "Error: multiple entry files specified\n"; exit 1);
      parse rest
  in
  parse (List.tl (Array.to_list Sys.argv));

  let input_path = match !input_file with
    | Some p -> p
    | None   -> Printf.eprintf "Error: no entry file specified\n%s" usage; exit 1
  in

  (match !custom_file with
   | Some path ->
     if Sys.file_exists path then
       Typst_dict.load_custom path
     else begin
       Printf.eprintf "Error: unknown custom commands file: %s\n" path;
       exit 1
     end
   | None ->
     if Sys.file_exists Typst_dict.default_custom_file then
       Typst_dict.load_custom Typst_dict.default_custom_file);

  let input =
    let ic = open_in input_path in
    let n  = in_channel_length ic in
    let s  = Bytes.create n in
    really_input ic s 0 n;
    close_in ic;
    Bytes.to_string s
  in

  let lexbuf   = Sedlexing.Utf8.from_string input in
  let provider = Sedlexing.with_tokenizer Lexer.token lexbuf in
  let ast =
    try MenhirLib.Convert.Simplified.traditional2revised Parser.prog provider
    with Parser.Error ->
      let pos = fst (Sedlexing.lexing_positions lexbuf) in
      Printf.eprintf "Parse error at line %d, column %d\n"
        pos.Lexing.pos_lnum
        (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
      exit 1
  in
  print_string (Printer.emit ast ^ "\n")