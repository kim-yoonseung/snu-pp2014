open CommonGrade
open Hw9_2

let error : float = 0.0001

let abs (x:float) =
  if x > 0. then x else (-1. *. x)

(*
let rec same (m1:Markov.matrix) (m2:Markov.matrix) (n:int) : bool = 
  if n = 0 then true
  else
    if (abs ((Markov.ij m1 (n-1) 0) -. (Markov.ij m2 (n-1) 0))) < error then
      same m1 m2 (n-1)
    else false

let rec sum (m:Markov.matrix) (n:int) : float = 
  if (n = 0) then 0.
  else (sum m (n-1)) +. Markov.ij m (n-1) 0
*)

let rec same (m1:Markov.matrix) (m2:Markov.matrix) (n:int) : bool = 
  if n = 0 then true
  else
    if (abs ((Markov.ij m1 0 (n-1)) -. (Markov.ij m2 0 (n-1)))) < error then
      same m1 m2 (n-1)
    else false

let rec sum (m:Markov.matrix) (n:int) : float = 
  if (n = 0) then 0.
  else (sum m (n-1)) +. Markov.ij m 0 (n-1)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.3.;1./.3.;1./.3.] 
           (Markov.column [1./.2.;1./.2.;0.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.3.;1./.3.;1./.3.] 
           (Markov.column [1./.2.;1./.2.;0.]))
      in 
      let minit1 = Markov.column [1./.3.;1./.3.;1./.3.] in
      let minit2 = Markov.column [1./.2.;1./.2.;0.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)


let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [1.;0.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [0.;1./.2.;1./.2.]))
      in
      let mat2 = Markov.add_column [1.;0.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [0.;1./.2.;1./.2.]))
      in
      let minit1 = Markov.column [1./.3.;1./.3.;1./.3.] in
      let minit2 = Markov.column [1./.2.;1./.2.;0.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)



let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
        (Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
           (Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
              (Markov.column [0.;1./.2.;1./.2.;0.])))
      in
      let mat2 = Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
        (Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
           (Markov.add_column [1./.3.;1./.3.;0.;1./.3.] 
              (Markov.column [0.;1./.2.;1./.2.;0.])))
      in
      let minit1 = (Markov.column [1./.4.;1./.4.;1./.4.;1./.4.]) in
      let minit2 = Markov.column [1./.2.;0.;1./.2.;0.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 4 && 
        (sum result1 4) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [1./.5.;1./.5.;1./.5.;1./.5.;1./.5.] 
        (Markov.add_column [0.;0.;0.;1./.2.;1./.2.] 
           (Markov.add_column [0.;1./.2.;0.;0.;1./.2.] 
              (Markov.add_column [1./.2.;0.;0.;0.;1./.2.] 
                 (Markov.column [0.;0.;1./.2.;0.;1./.2.]))))
      in
      let mat2 = Markov.add_column [1./.5.;1./.5.;1./.5.;1./.5.;1./.5.] 
        (Markov.add_column [0.;0.;0.;1./.2.;1./.2.] 
           (Markov.add_column [0.;1./.2.;0.;0.;1./.2.] 
              (Markov.add_column [1./.2.;0.;0.;0.;1./.2.] 
                 (Markov.column [0.;0.;1./.2.;0.;1./.2.]))))
      in
      let minit1 = (Markov.column [1./.5.;1./.5.;1./.5.;1./.5.;1./.5.]) in
      let minit2 = Markov.column [1./.3.;0.;1./.3.;0.;1./.3.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 5 && 
        (sum result1 5) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [1./.3.;1./.3.;1./.3.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [1./.3.;1./.3.;1./.3.]))
      in
      let minit1 = (Markov.column [1./.3.;1./.3.;1./.3.]) in
      let minit2 = Markov.column [1./.2.;1./.2.;0.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [1./.4.;1./.4.;1./.4.;1./.4.] 
        (Markov.add_column [0.;1.;0.;0.] 
           (Markov.add_column [1.;0.;0.;0.] 
              (Markov.column [0.;0.;1.;0.])))
      in
      let mat2 = Markov.add_column [1./.4.;1./.4.;1./.4.;1./.4.] 
        (Markov.add_column [0.;1.;0.;0.] 
           (Markov.add_column [1.;0.;0.;0.] 
              (Markov.column [0.;0.;1.;0.])))
      in
      let minit1 = (Markov.column [1./.4.;1./.4.;1./.4.;1./.4.]) in
      let minit2 = Markov.column [1./.3.;1./.3.;0.;1./.3.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 4 && 
        (sum result1 4) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.2.;0.;1./.2.] 
           (Markov.column [0.;1.;0.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.2.;0.;1./.2.] 
           (Markov.column [0.;1.;0.]))
      in
      let minit1 = (Markov.column [1./.3.;1./.3.;1./.3.]) in
      let minit2 = Markov.column [1./.2.;0.;1./.2.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1.;0.;0.] 
           (Markov.column [0.;0.;1.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1.;0.;0.] 
           (Markov.column [0.;0.;1.]))
      in
      let minit1 = (Markov.column [1./.3.;1./.3.;1./.3.]) in
      let minit2 = Markov.column [1./.2.;0.;1./.2.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [0.;0.;1.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [0.;0.;1.] 
           (Markov.column [0.;0.;1.]))
      in
      let minit1 = (Markov.column [1./.3.;1./.3.;1./.3.]) in
      let minit2 = Markov.column [1./.2.;0.;1./.2.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)

let _ =
  output
    (fun () ->
      let mat1 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.2.;0.;1./.2.] 
           (Markov.column [0.;1.;0.]))
      in
      let mat2 = Markov.add_column [0.;1.;0.] 
        (Markov.add_column [1./.2.;0.;1./.2.] 
           (Markov.column [0.;1.;0.]))
      in
      let minit1 = Markov.column [1./.3.;1./.3.;1./.3.] in
      let minit2 = Markov.column [1./.2.;0.;1./.2.] in
      let result1 = Markov.markov_limit mat1 minit1 in
      let result2 = Markov.markov_limit mat2 minit2 in
      same result1 result2 3 && 
        (sum result1 3) -. 1. < error)
