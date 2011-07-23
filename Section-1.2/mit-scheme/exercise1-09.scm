;;
;; Exercise 1.9
;;
;; Each of the following two procedures defines a method for adding two positive integers in terms
;; of the procedures `inc`, which increments its argument by 1, and `dec`, which decrements its 
;; argument by 1.
;;

;; 
;; Supporting procedures 
;; (Note that we may not use the procedure and/or special
;; form "+" in the definition of the inc/dec procedures)
;;
(define (inc a) (- a -1))
(define (dec a) (- a 1))

;;
;; The following procedure defines a RECURSIVE process:
;;
(define (+ a b)
  (if (= a 0)
      b
      (inc (+ (dec a) b))))

;;
;; We examine evaluation of the expression (+ 4 5):
;;
(+ 4 5)
(inc (+ (dec 4) 5))
(inc (+ 3 5))
(inc (inc (+ (dec 3) 5)))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ (dec 2) 5))))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ (dec 1) 5)))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9

;;
;; The following procedure defines an ITERATIVE process:
;;
(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))

;;
;; We examine evaluation of the expression (+ 4 5):
;;
(+ 4 5)
(+ (dec 4) (inc 5))
(+ 3 6)
(+ (dec 3) (inc 6))
(+ 2 7)
(+ (dec 2) (inc 7))
(+ 1 8)
(+ (dec 1) (inc 8))
(+ 0 9)
9