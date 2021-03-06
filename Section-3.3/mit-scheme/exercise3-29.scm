;;
;; Exercise 3.29
;;
;; Another way to construct an or-gate is as a compound digital logic device, 
;; built from and-gates and inverters. Define a procedure "or-gate" that 
;; accomplishes this. What is the delay time of the or-gate in terms of 
;; and-gate-delay and inverter-delay?
;;

;;
;; We can invert both inputs, attach them to an and-gate, and then invert
;; the output of the and-gate:
;;
;;              _
;;             | \ 
;;  INPUT 1 ---|  o---+
;;             |_/    |   +------)      _
;;                    +---|       )    | \
;;                        |        )---|  o--- OUTPUT 
;;              _     +---|       )    |_/
;;             | \    |   +------)
;;  INPUT 2 ---|  o---+
;;             |_/ 
;; 

;;
;; ------------------------------------------------------ 
;; | I1 | ~I1 | I2 | ~I2 | (~I1 && ~I2) | ~(~I1 && ~I2) |
;; ------------------------------------------------------ 
;; |  1 |  0  |  1 |  0  |       0      |        1      |
;; |  1 |  0  |  0 |  1  |       0      |        1      |
;; |  0 |  1  |  1 |  0  |       0      |        1      |
;; |  0 |  1  |  0 |  1  |       1      |        0      |
;; ------------------------------------------------------
;;

;;
;; Define the or-gate:
;;
(define (or-gate i1 i2 output)
  (let ((not-i1 (make-wire))
	(not-i2 (make-wire))
	(b (make-wire)))
    (inverter i1 not-i1)
    (inverter i2 not-i2)
    (and-gate not-i1 not-i2 b)
    (inverter b output)
    'ok))

;;
;; The delay time for this or-gate is twice the delay time for the 
;; inverter plus the delay time for the and-gate, or in other words:
;;
;;   D(or) = D(and) + 2*D(inv)
;;

;;
;; Cannot unit test the or-gate yet, since we do not have a definition 
;; for make-wire.
;;