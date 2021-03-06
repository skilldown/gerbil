;;; -*- Gerbil -*-
;;; (C) vyzo at hackzen.org
;;; :std/iter unit-tests

(import :std/test
        :std/iter)
(export iter-test)

(def (my-generator n)
  (lambda ()
    (let lp ((k 0))
      (when (< k n)
        (yield k)
        (lp (1+ k))))))

(def iter-test
  (test-suite "test :std/iter library"
    (test-case "test imperative for"
      (def (test-for-1)
        (for (x '(1 2 3))
          (displayln x)))
      (check-output (test-for-1) "1\n2\n3\n")

      (def (test-for-2)
        (for ((x '(1 2 3))
              (y '#(a b c d)))
          (displayln x " " y)))
      (check-output (test-for-2) "1 a\n2 b\n3 c\n")

      (def (test-for-3)
        (for (x (in-range 3))
          (displayln x)))
      (check-output (test-for-3) "0\n1\n2\n")

      (def (test-for-4)
        (for (x (in-range 3 3))
          (displayln x)))
      (check-output (test-for-4) "3\n4\n5\n")

      (def (test-for-5)
        (for (x (in-range 3 3 2))
          (displayln x)))
      (check-output (test-for-5) "3\n5\n7\n")

      (def (test-for-6)
        (for (x (my-generator 3))
          (displayln x)))
      (check-output (test-for-6) "0\n1\n2\n"))

    (test-case "test folding macros"
      (def (test-for/collect-1)
        (for/collect ((x '(1 2 3))
                      (y '#(a b c d)))
          (cons x y)))
      (check (test-for/collect-1) => '((1 . a) (2 . b) (3 . c)))

      (def (test-for/collect-2)
        (for/collect ((x (in-naturals 1))
                      (y '#(a b c d)))
          (cons x y)))
      (check (test-for/collect-2) => '((1 . a) (2 . b) (3 . c) (4 . d)))
      
      (def (test-for/collect-3)
        (for/collect (x (my-generator 3)) x))
      (check (test-for/collect-3) => '(0 1 2))

      (def (test-for/fold)
        (for/fold (r []) ((x '(1 2 3)) (y '#(a b c d)))
          (cons* x y r)))
      (check (test-for/fold) => '(3 c 2 b 1 a)))))
