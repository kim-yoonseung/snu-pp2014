#lang racket

(require "hw3-3-library.rkt")
(require "hw3-3.rkt")
(require "common-grade.rkt")

(define (move-location i j d)
  (cond [(equal? d 0) (cons (- i 1) j)]
        [(equal? d 1) (cons i (- j 1))]
        [(equal? d 2) (cons (+ i 1) j)]
        [(equal? d 3) (cons i (+ j 1))]
        ))

(define (find-open row index checknum)
  (if (null? row) '()
      (if (list-ref (car row) checknum)
          (cons index (find-open (cdr row) (+ 1 index) checknum))
          (find-open (cdr row) (+ 1 index) checknum)
          )))

(define (find-start maze)
  (let [(n (caar maze)) (m (cdar maze)) (lst (cdr maze))]
    (let [(fst-row (car lst)) (last-row (list-ref lst (- n 1)))]
      (let [(starts (find-open fst-row 0 0))]
        (if (null? starts) 0
            (if (> (length starts) 1) 0
                (cons 0 (car starts))
                ))))))

(define (find-end maze)
  (let [(n (caar maze)) (m (cdar maze)) (lst (cdr maze))]
    (let [(fst-row (car lst)) (last-row (list-ref lst (- n 1)))]
      (let [(ends (find-open last-row 0 2))]
        (if (null? ends) 0
            (if (> (length ends) 1) 0
                (cons (- n 1) (car ends))
                ))))))

(define (next-dir k)
  (remainder (+ k 1) 4))

(define (is-open? maze cur dir)
  (list-ref (list-ref (list-ref (cdr maze) (car cur)) (cdr cur)) dir))

(define (find-next maze cur from)
  (if (is-open? maze cur (next-dir from)) (next-dir from)
      (find-next maze cur (next-dir from))
      ))

(define (oppositdir k)
  (remainder (+ k 2) 4))

(define (findway maze cur from start end)
  (if (equal? cur end) #t
      (let [(nextdir (find-next maze cur from))]
        (if (and (equal? cur start) (= nextdir 0)) #f
            (findway maze (move-location (car cur) (cdr cur) nextdir) (oppositdir nextdir) start end)
            ))))
      

(define (check-maze maze)
  (define start (find-start maze))
  (define end (find-end maze))
  (if (or (equal? 0 start) (equal? 0 end)) #f
      (findway maze start 0 start end)
      ))


(output (lambda () (equal? #t (check-maze (mazeGen 3 3)))))
(output (lambda () (equal? #t (check-maze (mazeGen 3 3)))))
(output (lambda () (equal? #t (check-maze (mazeGen 10 10)))))
(output (lambda () (equal? #t (check-maze (mazeGen 10 8)))))
(output (lambda () (equal? #t (check-maze (mazeGen 4 6)))))