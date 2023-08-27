module FileReader = struct
  let read filepath =
    let ic = open_in filepath in
    let data = In_channel.input_all ic in
    let rec parse_lines lines lst =
      match lines with
      | [] -> List.rev lst
      | "" :: xs -> parse_lines xs lst
      | x :: xs ->
          let xv = int_of_string x in
          parse_lines xs (xv :: lst)
    in
    let lines = String.split_on_char '\n' data in
    parse_lines lines []
end

let find_sum lst sum =
  let find_fun x y = x + y = sum in
  let rec aux lst sum =
    match lst with
    | [] | [ _ ] -> None
    | x :: xs -> (
        match List.find_opt (find_fun x) xs with
        | Some value -> Some (x, value)
        | None -> aux xs sum)
  in
  aux lst sum

let find_sum_3 (lst : int list) (sum : int) =
  let rec aux lst sum =
    match lst with
    | [] | [ _ ] -> None
    | x :: xs -> (
        let new_sum = sum - x in
        match find_sum xs new_sum with
        | None -> aux xs sum
        | Some (b, c) -> Some (x, b, c))
  in
  aux lst sum

let usage_msg = "day01 <file>"
let verbose = ref false
let input_file = ref ""
let anon_fun filename = input_file := filename
let speclist = []
let () = Arg.parse speclist anon_fun usage_msg

let () =
  let numbers = FileReader.read !input_file in
  match find_sum numbers 2020 with
  | None -> Printf.printf "Did not find solution"
  | Some (a, b) -> (
      Printf.printf "%d\n" (a * b);
      match find_sum_3 numbers 2020 with
      | None -> Printf.printf "Did not find solution"
      | Some (a, b, c) -> Printf.printf "%d\n" (a * b * c))
