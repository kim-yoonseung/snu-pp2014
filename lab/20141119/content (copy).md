# 프로그래밍의 원리 실습 #

2013년 11월 06일 (수) 16:00-17:50 조교
[조성근](http://ropas.snu.ac.kr/~skcho),
[강지훈](http://ropas.snu.ac.kr/~jhkang)

실습을 통해 정적 타입(static type)의 이점을 알아봅시다. 이번 실습에서는
처음으로 OCaml을 사용하게 됩니다.


### 타입 에러 ###

먼저 다음 [treeWrong.rkt](treeWrong.rkt)를 봅시다. 나뭇잎(leaf)에만 정수값이
달려있는 이진나무 구조입니다. 나뭇잎(leaf)을 만들고 사용하는 함수들,
줄기(branch)를 만들고 사용하는 함수들, 그리고 예쁘게 출력하는 함수가
있습니다.

현재 주어진 코드는 다음과 같이 불평하며 잘 실행되지 않습니다:

```
string-append: contract violation
  expected: string?
  given: 0
  argument position: 2nd
  other arguments...:
   "("
   " "
   1
   ")"
  context...:
   /Users/idiothinker/Works/pp-material/20131106/treeWrong.rkt: [running body]
```

간단히 의미를 살펴보면, 문자열(string)이 와야 할 자리에 ```0```이 와서
잘 실행이 되지 않았다고 합니다. 어디가 잘못되었을까요? 코드 마지막 줄이
잘 실행되어 예상되는 값이 나오도록 변경하세요. 힌트: 문제는 35줄의
```(leaf-value t)```에 있습니다.


### 정적 타입 ###

위의 예제를 보아하니, Racket에 대해 불만이 생깁니다.

* 이와 같이 너무 뻔한 오류는 잘 알려주면 좋겠습니다.
* 뻔하다는건 ```pprint-tree```의 출력이 ```string```인데,
  ```(leaf-value t)```는 그 규약을 지키지 않는다는게 너무 뻔하다는
  겁니다.
* 다음과 같은 에러 메시지가 나오면 좋겠습니다: ```type error: (leaf-value t)
  is an int, but is expected to be a string.```

해결은 수업시간에 배운 것처럼 정적 타입을 지원하는 언어를 사용하는
것입니다! 이번 실습시간에는 OCaml을 사용해봅시다.

### OCaml ###

앞서 제시한 Racket 코드와 거의 비슷한 일을 하는 [tree.ml](tree.ml)를
봅시다. 파일을 다운로드받고,
[try.ocamlpro.com](http://try.ocamlpro.com)에
드래그-앤-드롭해봅니다. 그럼 중간에 ```(((0 1) 2) (3 4))```라고
출력되는걸 볼 수 있습니다.

참고: 실습실 컴퓨터에도 OCaml이 깔려 있습니다. OCamlWinPlus라는
프로그램을 실행시켜 따라해볼 수 있습니다.

코드를 한줄씩 이해해봅시다.

```ocaml
type tree =
  | Leaf of int
  | Branch of (tree * tree);;
```

tree라는 타입을 정의합니다. Racket에서와는 달리, 타입을 명시적으로
정의할 수 있으며 또 **정의해야만** 합니다. Tree라는 타입은 Racket
프로그램에서처럼 두종류로 이루어져 있습니다. 나뭇잎은 정수 하나를
가지고 있고, 줄기는 나무 두개를 가지고 있습니다.

```ocaml
let rec pprint_tree (t: tree): string =
  match t with
  | Leaf v -> string_of_int v
  | Branch (l, r) ->
     "(" ^ (pprint_tree l) ^ " " ^ (pprint_tree r) ^ ")";;
```

가장 중요한 구문은 ```match ??? with```입니다. Racket 프로그램에서는
```(if (is-branch? t) ??? ???)```와 같이 했었죠? OCaml에서는 종류에
따라 다르게 구현하고 싶을 때 ```match``` 구문을 씁니다. 잘
기억해두세요!

그외에도 ```string_of_int```가 int를 string으로 바꾸기 위해 사용된 걸
알수 있고, 문자열을 더하기 위해 ```^``` 연산자가 사용된 걸 볼 수
있습니다.

```ocaml
let ex = Branch (Branch (Branch (Leaf 0, Leaf 1), Leaf 2), Branch (Leaf 3, Leaf 4));;
let _ = print_endline (pprint_tree ex);;
```

OCaml로 프로그래밍하면 여러가지 장점이 있습니다.

* Racket 코드에 비해서 훨씬 간결한 코드를 작성할 수 있습니다. 한번
  확인해보세요.
* 타입 오류를 컴파일할 때 다 잡아줍니다. 예를 들어 주어진
[treeWrong.ml](treeWrong.ml)을 실행해보세요. `File "treeWrong.ml",
line 7, characters 14-15: Error: This expression has type int but an
expression was expected of type string`와 같은 친절하고 도움이 되는
에러 메시지를 얻을 수 있습니다.

### Ocaml 프로그래밍 ###

나무 구현을 잘 보고, [list.ml](list.ml)의 ```raise TODO``` 부분을 잘 워
넣어보세요. 마지막줄에서 의도한대로 결과가 나오면 됩니다.

### OCaml 개발 환경 ###

앞으로 나올 실습 과제와 숙제는 OCaml로 작성해야 할 문제가 나올
예정입니다. 다음과 같은 환경을 추천합니다.

* OCaml 버전 4.00.1에서 채점하겠습니다.
* [다운로드](http://caml.inria.fr/download.en.html) 페이지에서
  다운로드받아 설치하세요. 참고로 실습실에는 이미 OCaml 4.00.1이 깔려
  있습니다.
* Linux 유저의 경우, Emacs/Vim + make를 추천합니다.
  + Emacs의 경우
    [Tuareg](http://www.emacswiki.org/emacs/TuaregMode)이라는
    플러그인도 있습니다.
* 그 외의 경우, [Eclipse](http://eclipse.org) +
  [OcaIDE](http://www.algo-prog.info/ocaide/)를 추천합니다. 구체적인
  설치 방법은
  [지난 실습자료](http://ropas.snu.ac.kr/~ta/4190.210/12/practice/ocaml_tutorial.pdf)를
  참조하세요.
* 어찌되었건 1) OCaml syntax highlighting이 되는 편집기와 2) OCaml
  코드를 실행할 수 있는 인터프리터 혹은 컴파일러가 구비되면 됩니다.
