;;
;; Exercise 2.43
;;
;; [WORKING]
;;

;;
;; Supporting procedures:
;;
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	    (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

;;
;; Let's also review the definition of "map":
;;
(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
	    (map proc (cdr items)))))

;;
;; Let's first look at the application of flatmap from Exercise 2.42:
;;
(flatmap 
 (lambda (rest-of-queens)
   (map (lambda (new-row)
	  (adjoin-position new-row k rest-of-queens))
	(enumerate-interval 1 board-size)))
 (queen-cols (- k 1)))

;;
;; Expanding the definition of flatmap can make it easier to see what is going on:
;;
(accumulate append '() (map 
			(lambda (rest-of-queens)
			  (map (lambda (new-row)
				 (adjoin-position new-row k rest-of-queens))
			       (enumerate-interval 1 board-size)))
			(queen-cols (- k 1))))

;;
;; Using this method, the following procedures are called the following number of times:
;;
;;  (queen-cols (- k 1)) ==> 1 CALL
;;  (enumerate-interval 1 board-size) ==> # OF ELEMENTS IN (QUEEN-COLS (- K 1))
;;  (adjoin-position new-row k rest-of-queens) ==> (# OF ELEMENTS IN (QUEEN-COLS (- K 1)))^2
;;
;; Note that "adjoin-position", which is invoked the most frequently, is 
;; a relatively cheap operation, only making a linear-time call to "cons".
;;

;;
;; Now let's look at Louis Reasoner's application of flatmap:
;;
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
	  (adjoin-position new-row k rest-of-queens))
	(queen-cols (- k 1))))
 (enumerate-interval 1 board-size))

;;
;; Again, expanding the definition of flatmap out can make it easier to see what's going on:
;;
(accumulate append '() (map
			(lambda (new-row)
			  (map (lambda (rest-of-queens)
				 (adjoin-position new-row k rest-of-queens))
			       (queen-cols (- k 1))))
			(enumerate-interval 1 board-size)))

;;
;; Using this method, the following procedures are called the following number of times:
;;
;;  (enumerate-interval 1 board-size) ==> 1 CALL
;;  (lambda (new-row) (map (lambda (rest-of-queens) (adjoin-position new-row k rest-of-queens)) (queen-cols (- k 1)))) ==> BOARD-SIZE CALLS (i.e., 8 CALLS)
;;  (queen-cols (- k  1)) ==> BOARD-SIZE CALLS (i.e., 8 CALLS)
;;  (lambda (rest-of-queens) (adjoin-position new-row k rest-of-queens)) ==> BOARD_SIZE * # OF ELEMENTS IN (QUEEN-COLS (- K 1))
;; 



;;
;; Using this procedure, one invocation of "flatmap" will execute
;; the following procedures the following number of times:
;;
;;  (enumerate-interval 1 board-size) ==> 1 call
;;  (queen-cols (- k 1) ==> 1 call




;;
;; Let's step through some call graphs.
;;
;; As we showed in the previous exercise, if the board size is 4
;; then (queen-cols 3) will be:
;;
;;  ((1 4 2) (2 4 1) (3 1 4) (4 1 3))
;;
;; So the call to flatmap, at the iteration with k=4, might look something like:
;;
(flatmap
 (lambda (rest-of-queens)
   (map (lambda (new-row)
	  (adjoin-position new-row 4 rest-of-queens))
	(enumerate-interval 1 board-size)))
 '((1 4 2) (2 4 1) (3 1 4) (4 1 3)))

(flatmap
 (lambda (rest-of-queens)
   (map (lambda (new-row)
	  (adjoin-position new-row 4 rest-of-queens))
	'(1 2 3 4)))
 '((1 4 2) (2 4 1) (3 1 4) (4 1 3)))

'((1 1 4 2) (2 1 4 2) (3 1 4 2) (4 1 4 2)
 (1 2 4 1) (2 2 4 1) (3 2 4 1) (4 2 4 1)
 (1 3 1 4) (2 3 1 4) (3 3 1 4) (4 3 1 4)
 (1 4 1 3) (2 4 1 3) (3 4 1 3) (4 4 1 3))

;;
;; Let's look at what the call graph looks like using Louis Reasoner's approach:
;;
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
	  (adjoin-position new-row k rest-of-queens))
	(queen-cols (- k 1))))
 (enumerate-interval 1 board-size))

(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
	  (adjoin-position new-row 4 rest-of-queens))
	'((1 4 2) (2 4 1) (3 1 4) (4 1 3))))
 '(1 2 3 4))