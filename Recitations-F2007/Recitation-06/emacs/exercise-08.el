;;
;; Working definitions
;;
(defun make-units (C L H)
 (list C L H))
(defun get-units-C (x) (car x))
(defun get-units-L (x) (cadr x))
(defun get-units-H (x) (cadr (cdr x)))

(defun make-class (number units)
 (list number units))
(defun get-class-number (x) (car x))
(defun get-class-units (x) (cadr x))

(defun get-class-total-units (class)
 (let ((units (get-class-units class)))
  (+ 
   (get-units-C units)
   (get-units-L units)
   (get-units-H units))))

(defun same-class? (c1 c2)
 (equal (get-class-number c1) (get-class-number c2)))

;;
;; Working definitions (HOPs)
;;
(defun make-student (number sched-checker)
  (list number (list) sched-checker))
(defun get-student-number (x) (car x))
(defun get-student-schedule (x) (cadr x))
(defun get-student-checker (x) (cadr (cdr x)))

(defun update-student-schedule (student schedule)
  (let ((test-function (get-student-checker student)))
    (if (funcall test-function schedule)
	(list (get-student-number student)
	                  schedule
			            test-function)
      (error "Invalid schedule!"))))

;;
;; Previous solutions
;;
(defun empty-schedule () '())
(defun add-class (class schedule)
  (append schedule (list class)))
(defun total-scheduled-units (schedule)
  (defun iter (seq total)
    (if (null seq)
	total
      (let ((class (car seq)))
	(iter (cdr seq) (+ total (get-class-total-units class))))))
  (iter schedule 0))

;;
;; Use the more complicated definition of "drop-class" so we don't
;; have to re-implement the "filter" procedure:
;;
(defun drop-class (schedule classnum)
  ;;
  ;; "Temp" class is defined so that we can use the 
  ;; procedure "same-class" that is provided in the "API"
  ;;
  (let ((temp-class (make-class classnum '())))
    (defun diter (elems)
      (if (null elems)
	          '()
	(let ((class (car elems)))
	          (if (same-class? class temp-class)
		                  (diter (cdr elems))
		                (append (list class) (diter (cdr elems)))))))
    (diter schedule)))

(defun credit-limit (schedule max-credits)
  (defun citer (elems)
    (if (null elems)
	'()
      (let ((class (car elems))
	                (credits (total-scheduled-units elems)))
	(if (> credits max-credits)
	                (citer (drop-class elems (get-class-number class)))
	        elems))))
  (citer schedule))

(defun make-schedule-checker-1 ()
  (lambda (schedule)
    (> (length schedule) 0)))

(defmacro make-schedule-checker-2 (var)
  (list 'lambda (list 'schedule) (list '<= (list 'total-scheduled-units 'schedule) var)))

;;
;; Basic Classes
;;
(setq calc1 (make-class 'CALC-101 (make-units 4 4 4)))
(setq calc2 (make-class 'CALC-102 (make-units 4 4 4)))
(setq algebra (make-class 'ALGB-152 (make-units 3 3 3)))
(setq diff-eqs (make-class 'DIFF-201 (make-units 3 3 3)))
(setq us-history (make-class 'HIST-122 (make-units 4 4 4)))
(setq world-history (make-class 'HIST-324 (make-units 4 4 4)))
(setq basket-weaving (make-class 'BASKETS (make-units 1 1 1)))

;;
;; Exercise 8
;; 
;; Write a procdure that takes a schedule and returns a list of the class numbers in the schedule. Use map.
;;
(defun class-numbers (schedule)
  (mapcar #'(lambda (x) (get-class-number x)) schedule))

;;
;; Let's run some unit tests:
;;
(define s1 (empty-schedule))
(define s2 (empty-schedule))
(define s2 (add-class calc1 s2))
(define s2 (add-class algebra s2))
(define s2 (add-class diff-eqs s2))
(define s3 s2)
(define s3 (add-class us-history s3))
(define s3 (add-class world-history s3))
(define s4 s3)
(define s4 (add-class basket-weaving s4))

(class-numbers s1)
;; ==> nil
(class-numbers s2)
;; ==> (CALC-101 ALGB-152 DIFF-201)
(class-numbers s3)
;; ==> (CALC-101 ALGB-152 DIFF-201 HIST-122 HIST-324)
(class-numbers s4)
;; ==> (CALC-101 ALGB-152 DIFF-201 HIST-122 HIST-324 BASKETS)