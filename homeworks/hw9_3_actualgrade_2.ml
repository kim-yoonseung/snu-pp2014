open CommonGrade
open Hw9_3

let rec exp_repeat (iter:int) (e:exp) (inputs:int list) : int * (int list) = 
  if iter = 0
  then (0,inputs)
  else 
    let (r1,i1) = exp_eval_rec e inputs in
    let (r2,i2) = exp_repeat (iter-1) e i1 in
    (r1+r2, i2)

and exp_eval_rec (e:exp) (inputs:int list) : int * (int list) =
  match e with
  | Num i -> (i,inputs)
  | Add (e1,e2) -> 
    let (r1,i1) = exp_eval_rec e1 inputs in
    let (r2,i2) = exp_eval_rec e2 i1 in
    (r1+r2,i2)
  | Minus e1 ->
    let (r1,i1) = exp_eval_rec e1 inputs in
    (-r1,i1)
  | Read -> (List.hd inputs,List.tl inputs)
  | If (e1,e2,e3) ->
    let (r1,i1) = exp_eval_rec e1 inputs in
    if r1 = 0
    then exp_eval_rec e3 i1
    else exp_eval_rec e2 i1
  | Repeat (e1,e2) ->
    let (r1,i1) = exp_eval_rec e1 inputs in
    exp_repeat r1 e2 i1

let exp_eval (e:exp) (inputs:int list) : int = fst (exp_eval_rec e inputs)

let rec cmd_eval_rec
    (c:cmd list) (idx:int) (inputs:int list) (m:var->int) (tg:tag->int)
    : int = 
  match List.nth c idx with
  | HasNum (x,i) -> 
    let new_m = fun k -> if k = x then i else m k in
    cmd_eval_rec c (idx+1) inputs new_m tg
  | HasVar (x,y) ->
    let new_m = fun k -> if k = x then m y else m k in
    cmd_eval_rec c (idx+1) inputs new_m tg
  | HasSum (x,y,z) ->
    let new_m = fun k -> if k = x then m y + m z else m k in
    cmd_eval_rec c (idx+1) inputs new_m tg
  | HasSub (x,y,z) ->
    let new_m = fun k -> if k = x then m y - m z else m k in
    cmd_eval_rec c (idx+1) inputs new_m tg
  | HasRead x ->
    let new_m = fun k -> if k = x then (List.hd inputs) else m k in
    cmd_eval_rec c (idx+1) (List.tl inputs) new_m tg
  | Say x -> m x
  | Goto (t,x) -> 
    if m x = 0 
    then cmd_eval_rec c (idx+1) inputs m tg
    else cmd_eval_rec c (tg t) inputs m tg
  | Tag _ -> failwith "cmd_eval_rec:tag"
  | Seq _ -> failwith "cmd_eval_rec:seq"

let rec make_cl_rec (c:cmd) (tg:tag->int) (idx:int) 
    : cmd list * (tag->int) * int = 
  match c with
  | HasNum _
  | HasVar _
  | HasSum _
  | HasSub _
  | HasRead _
  | Say _
  | Goto _ -> ([c],tg,idx+1)
  | Tag (t,c') -> 
    let new_tg = fun k -> if k = t then idx else tg k in
    make_cl_rec c' new_tg idx
  | Seq (c1,c2) ->
    let (cl1,tg1,idx1) = make_cl_rec c1 tg idx in
    let (cl2,tg2,idx2) = make_cl_rec c2 tg1 idx1 in
    (cl1@cl2,tg2,idx2)

exception NoBind
exception NoTagBind

let make_cl (c:cmd) : cmd list * (tag->int) = 
  let (cl,tg,_) = make_cl_rec c (fun _ -> raise NoTagBind) 0 in
  (cl,tg)

let cmd_eval (c:cmd) (inputs:int list) : int =
  let (cl,tg) = make_cl c in
  cmd_eval_rec cl 0 inputs (fun _ -> raise NoBind) tg


let e1 = Repeat(Num 10,Num 3)
let e2 = Repeat(Add(Num 5,Num 5),Num 3)
let e3 = Repeat(Minus(Minus (Num 3)), Num 3)
let e4 = 
  Repeat(
    If(Add(Read,Num 100),Num 1,Num 2), 
    Read)
let e5 = Repeat(Minus(Num 1), Num 39)
let e6 = 
  If(Read, 
    Repeat(Minus(Num 4), Num 2), 
    Repeat(Num 1, Num 39))
let e7 = 
  If(
    If(Add(Read,Minus(Num 10)), 
       Num 0, 
       Read), 
    Repeat(Minus(Num (-1)), Num 39), 
    Repeat(Num 4, Num 2))

let _ = print_endline "check_exp"

let _ = output (fun () -> check_exp e1 = true)
let _ = output (fun () -> check_exp e2 = true)
let _ = output (fun () -> check_exp e3 = true)
let _ = output (fun () -> check_exp e4 = true)
let _ = output (fun () -> check_exp e5 = false)
let _ = output (fun () -> check_exp e6 = false)
let _ = output (fun () -> check_exp e7 = true)

let _ = print_endline "translate"

let _ = output (fun () -> let c1 = transform e1 in cmd_eval c1 [] = 30)
let _ = output (fun () -> let c2 = transform e2 in cmd_eval c2 [] = 30)
let _ = output (fun () -> let c3 = transform e3 in cmd_eval c3 [] = 9)
let _ = output (fun () -> let c4 = transform e4 in cmd_eval c4 [-100;3] = 6)
let _ = output (fun () -> let c4 = transform e4 in cmd_eval c4 [-37;5] = 5)
let _ = output (fun () -> let c4 = transform e4 in cmd_eval c4 [55;23] = 23)
let _ = output (fun () -> let c4 = transform e4 in cmd_eval c4 [100;80] = 80)
let _ = output (fun () -> let c7 = transform e7 in cmd_eval c7 [0] = 8)
let _ = output (fun () -> let c7 = transform e7 in cmd_eval c7 [10;0] = 8)
let _ = output (fun () -> let c7 = transform e7 in cmd_eval c7 [10;1] = 39)

let _ = print_endline "check_cmd"

let d1 = 
  Seq
   (Seq
     (Seq
       (Seq (Seq (HasNum ("x0", 0), HasNum ("x1", 10)),
         Seq (HasNum ("one", 1), Goto ("l0", "one"))),
       Seq (Seq (Tag ("l1", HasNum ("x2", 3)), HasSum ("x0", "x0", "x2")),
        HasSub ("x1", "x1", "one"))),
     Tag ("l0", Goto ("l1", "x1"))),
   Say "x0")

let d2 = 
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq (Seq (HasNum ("x6", 5), HasNum ("x7", 5)),
             HasSum ("x4", "x6", "x7")),
           HasNum ("x3", 0)),
         Seq (HasNum ("one", 1), Goto ("l2", "one"))),
       Seq (Seq (Tag ("l3", HasNum ("x5", 3)), HasSum ("x3", "x3", "x5")),
        HasSub ("x4", "x4", "one"))),
     Tag ("l2", Goto ("l3", "x4"))),
   Say "x3")

let d3 = 
  Seq
   (Seq
     (Seq (Seq (HasRead "x9", Goto ("l4", "x9")),
       Seq
        (Seq
          (Seq (Seq (HasNum ("x13", 0), HasNum ("x14", 3)),
            HasSub ("x10", "x13", "x14")),
          HasNum ("one", 1)),
        Goto ("l5", "one"))),
     Seq
      (Tag ("l4",
        Seq (Seq (HasNum ("x11", 1), HasNum ("x12", 5)),
         HasSum ("x10", "x11", "x12"))),
      Tag ("l5", HasVar ("x8", "x10")))),
   Say "x8")

let d4 = 
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq
             (Seq (Seq (HasRead "x18", Goto ("l8", "x18")),
               Seq (Seq (HasNum ("x19", 2), HasNum ("one", 1)),
                Goto ("l9", "one"))),
             Seq (Tag ("l8", HasNum ("x19", 1)),
              Tag ("l9", HasVar ("x16", "x19")))),
           HasNum ("x15", 0)),
         Seq (HasNum ("one", 1), Goto ("l6", "one"))),
       Seq (Seq (Tag ("l7", HasRead "x17"), HasSum ("x15", "x15", "x17")),
        HasSub ("x16", "x16", "one"))),
     Tag ("l6", Goto ("l7", "x16"))),
   Say "x15")

let d4 = 
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq
             (Seq (Seq (HasRead "x18", Goto ("l8", "x18")),
               Seq (Seq (HasNum ("x19", 2), HasNum ("one", 1)),
                Goto ("l9", "one"))),
             Seq (Tag ("l8", HasNum ("x19", 1)),
              Tag ("l9", HasVar ("x16", "x19")))),
           HasNum ("x15", 0)),
         Seq (HasNum ("one", 1), Goto ("l6", "one"))),
       Seq (Seq (Tag ("l7", HasRead "x17"), HasSum ("x15", "x15", "x17")),
        HasSub ("x16", "x16", "one"))),
     Tag ("l6", Goto ("l7", "x16"))),
   Say "x15")

let d5 = 
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq
             (Seq (Seq (HasRead "x18", Goto ("l8", "x18")),
               Seq (Seq (HasNum ("x19", 2), HasNum ("one", 1)),
                Goto ("l9", "one"))),
             Seq (Tag ("l8", HasNum ("x19", 1)),
              Tag ("l9", HasVar ("x16", "x19")))),
           HasNum ("x15", 0)),
         Seq (HasNum ("one", 1), Goto ("l6", "one"))),
       Seq (Seq (Tag ("l7", HasRead "x17"), HasSum ("x15", "x15", "x17")),
        HasSub ("x16", "x16", "one"))),
     Tag ("l7", Goto ("l7", "x16"))),
   Say "x15")

let d6 =
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq
             (Seq
               (Seq
                 (Seq (HasRead "x48",
                   Seq (Seq (HasNum ("x50", 0), HasNum ("x51", 10)),
                    HasSub ("x49", "x50", "x51"))),
                 HasSum ("x44", "x48", "x49")),
               Goto ("l24", "x44")),
             Seq
              (Seq
                (Seq (Seq (HasNum ("x46", 0), HasNum ("x47", 1)),
                  HasSub ("x45", "x46", "x47")),
                HasNum ("one", 1)),
              Goto ("l25", "one"))),
           Seq (Tag ("l24", HasNum ("x45", 0)),
            Tag ("l25", HasVar ("x36", "x45")))),
         Goto ("l18", "x36")),
       Seq
        (Seq
          (Seq
            (Seq
              (Seq (Seq (HasNum ("x42", 4), HasNum ("x37", 0)),
                Seq (HasNum ("one", 1), Goto ("l22", "one"))),
              Seq
               (Seq (Tag ("l23", HasNum ("x43", 2)),
                 HasSum ("x37", "x37", "x43")),
               HasSub ("x42", "x42", "one"))),
            Tag ("l22", Goto ("l26", "x42"))),
          HasNum ("one", 1)),
        Goto ("l19", "one"))),
     Seq
      (Tag ("l18",
        Seq
         (Seq
           (Seq
             (Seq
               (Seq (Seq (HasNum ("x40", 0), HasNum ("x41", -1)),
                 HasSub ("x38", "x40", "x41")),
               HasNum ("x37", 0)),
             Seq (HasNum ("one", 1), Goto ("l20", "one"))),
           Seq
            (Seq (Tag ("l21", HasNum ("x39", 39)),
              HasSum ("x37", "x37", "x39")),
            HasSub ("x38", "x38", "one"))),
         Tag ("l20", Goto ("l21", "x38")))),
      Tag ("l19", HasVar ("x35", "x37")))),
   Say "x35")

let d7 = 
  Seq
   (Seq
     (Seq
       (Seq
         (Seq
           (Seq
             (Seq (Seq (HasRead "x19", Goto ("l8", "x18")),
               Seq (Seq (HasNum ("x19", 2), HasNum ("one", 1)),
                Goto ("l9", "one"))),
             Seq (Tag ("l8", HasNum ("x19", 1)),
              Tag ("l9", HasVar ("x16", "x19")))),
           HasNum ("x15", 0)),
         Seq (HasNum ("one", 1), Goto ("l6", "one"))),
       Seq (Seq (Tag ("l7", HasRead "x17"), HasSum ("x15", "x15", "x17")),
        HasSub ("x16", "x16", "one"))),
     Tag ("l7", Goto ("l7", "x16"))),
   Say "x15")

let _ = output (fun () -> check_cmd d1 = true)
let _ = output (fun () -> check_cmd d2 = true)
let _ = output (fun () -> check_cmd d3 = true)
let _ = output (fun () -> check_cmd d4 = true)
let _ = output (fun () -> check_cmd d5 = false)
let _ = output (fun () -> check_cmd d6 = false)
let _ = output (fun () -> check_cmd d7 = false)

