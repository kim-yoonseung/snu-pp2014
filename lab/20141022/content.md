# Lab Session, Principles of Programming #

20141022 (Wed) 16:00-17:50
TA [Jeehoon Kang](http://sf.snu.ac.kr/jeehoon.kang), [Yoonseung Kim](http://sf.snu.ac.kr/yskim)

## Calculator ##

Implement a calculator. Complete the skeleton
[calculator.rkt](calculator.rkt).

Note that we will treat only

- constants,
- varables,
- additions,
- subtractions, and
- multiplications.

Your calculator is given:
- an expression, and
- values of variables.

See skeleton for more details.

## Complex numbers ##

Implement complex number data type. Complete the skeleton
[complex.rkt](complex.rkt).

You shall make two implementations:

- Descartes coordinate system: As usual, express as ```(x, y)```.
- Polar coordinate system: ```(r, θ)``` means the length ```r``` and
the angle ```θ```.

Both are represented as ```real X real```, so it is better to
distinguish with tagging. For example,

- ```(cons 'rect (cons 1 pi))``` means ```(1, pi)``` in the Descartes
  coordinate, and
- ```(cons 'polar (cons 1 pi))``` means ```(1, pi)``` in polar
coordinate, i.e. ```(-1,0)``` in Descartes coordinate.

Implement functions on Descartes coordinate system,
```racket
is-c-rect?: c-rect -> bool
c-rect-make: number * number -> c-rect
c-rect-real: c-rect -> number
c-rect-imaginary: c-rect -> number
```

and functions on polar coordinate system.
```racket
is-c-polar?: c-polar -> bool
c-polar-make: number * number -> c-polar
c-polar-real: c-polar -> number
c-polar-imaginary: c-polar -> number
```

Implement functions that works on both coordinate systems.
```racket
c-real: complex -> number
c-imaginary: complex -> number
c-angle: complex -> number
c-radius: complex -> number
c-conjugate: complex -> complex
```

See Wikipedia for more information on complex numbers and polar
coordinate system.

- [Complex number](http://en.wikipedia.org/wiki/Complex_number)
- [Polar coordinate system](http://en.wikipedia.org/wiki/Polar_coordinate_system)

```racket
(define c1 (c-rect-make 1 2))
(define c2 (c-rect-make 3 4))
(define c3 (c-polar-make 0.7 3))
(define c4 (c-polar-make 0.5 2))

(c-rect-real c1) ; 1
(c-rect-imaginary c2) ; 4
(c-polar-angle c3) ; 0.7
(c-polar-radius c4) ; 2
(is-c-rect? c1) ; #t
(is-c-rect? c3) ; #f
(is-c-polar? c4) ; #t
(c-real c1) ; 1
(c-real c3) ; 2.2945265618534654 = (* 3 (cos 0.7))
(c-imaginary c2) ; 4
(c-imaginary c4) ; 0.958851077208406 = (* 2 (sin 0.5))
(c-angle c1) ; 1.1071487177940904;(atan 2 1)
(c-angle c3) ; 0.7
(c-radius c2) ; 5 = (sqrt (+ (expt 3 2) (expt 4 2)))
(c-radius c4) ; 2

(define c5 (c-conjugate c1))
(define c6 (c-conjugate c3))

(c-real c5) ; 1
(c-imaginary c5) ; -2
(c-real c6) ; 2.2945265618534654
(c-imaginary c6) ; -1.932653061713073
```
