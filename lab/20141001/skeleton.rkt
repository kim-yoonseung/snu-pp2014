#lang racket

; Simple Functions
(define (plus1 x) (+ x 1)) ; int -> int
(define (plus2 x) (+ x 2)) ; int -> int
(define (mult3 x) (* x 3)) ; int -> int
(define (simpl x y) (+ (* x 3) y)) ; int * int -> int

; `circ` is the composition of functions, i.e., `((circ g f) x) = (g (f x))`.
(define (circ g f) ; (Y -> Z) * (X -> Y) -> (X -> Z)
  'TODO)

(print (equal? 7 ((circ plus1 mult3) 2))) ; shall be #t
(print (equal? 21 ((circ mult3 plus2) 5))) ; shall be #t

; `flip` reorders its arguments, i.e., `((flip f) x y) = (f y x)`.
(define (flip f) ; (X * Y -> Z) -> (Y * X -> Z)
  'TODO)

(print (equal? 3 ((flip /) 7 21))) ; shall be #t

; `map` transforms each element of a list, i.e., `(map f (list a b c)) = (list (f a) (f b) (f c))`.
(define (map f l) ; (X -> Y) * X list -> Y list
  'TODO)

(print (equal? (list 3 6 9) (map mult3 (list 1 2 3)))) ; shall be #t

; `reduceLeft` reduces the list from the left, i.e., `(reduceLeft r i (list a b c)) = (r (r (r i a) b) c)`.
(define (reduceLeft r i l) ; (X * Y -> X) * Y list -> X
  'TODO)

(print (equal? 58 (reduceLeft simpl 0 (list 1 2 3 4)))) ; shall be #t

; `reduceRight` reduces the list from the right, i.e., `(reduceLeft r (list a b c)) i = (r a (r b (r c i)))`.
(define (reduceRight r l i) ; (X * Y -> Y) * X list -> Y
  'TODO)

(print (equal? 30 (reduceRight simpl (list 1 2 3 4) 0))) ; shall be #t

; `filter` filters by a test function, i.e., `(filter test (list a b c)) = (list a c)`, if `(test a)` and `(test c)` are `#t` but `(test b)` is `#f`.
(define (filter test l) ; (X -> bool) * X list -> X list
  'TODO)

(print (equal? (list 1 3) (filter (lambda (x) (not (equal? 2 x))) (list 1 2 3)))) ; shall be #t

; Type Examples
(define x 1) ; int
(define y "Jessica") ; string
(define (z x) (string-append "SM and ")) ; string -> string
(define w (z y)) ; string
(define (a x y) (+ (* x 3) y)) ; int * int -> int
(define (id x) x) ; X -> X
