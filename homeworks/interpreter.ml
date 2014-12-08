
type exp = 
  | Num of int
  | Add of exp * exp
  | Minus of exp
  | Read
  | If of exp * exp * exp
  | Repeat of exp * exp
type var = string
type tag = string
type cmd = 
  | HasNum of var * int
  | HasVar of var * var
  | HasSum of var * var * var
  | HasSub of var * var * var
  | HasRead of var
  | Say of var
  | Goto of tag * var
  | Tag of tag * cmd
  | Seq of cmd * cmd


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
let _ = print_int (exp_eval e1 [])

let d1 = 
  Seq
   (Seq
     (Seq
       (Seq (Seq (HasNum ("x1", 10), HasNum ("x0", 0)),
         Seq (HasNum ("one", 1), Goto ("l0", "one"))),
       Seq (Seq (Tag ("l1", HasNum ("x2", 3)), HasSum ("x0", "x0", "x2")),
        HasSub ("x1", "x1", "one"))),
     Tag ("l0", Goto ("l1", "x1"))),
   Say "x0")
let _ = print_int (cmd_eval d1 [])

