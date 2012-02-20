;;
;; Exercise 5
;;
;; Write a procedure "(intersection seg1 seg2)" that returns a point where two
;; line segments intersect if they do, and returns #f if they do not intersect.
;; Be sure to honor the abstractions defined.
;;

;;
;; It will be useful to first define some helper methods.
;;
;; We would like to know both (a) the slope of the line; and (b) where the line
;; segment would intercept the y-axis if extended in both directions indefinitely
;; (i.e., extend the line segment to a full line).
;;
;; In other words, we would like to rewrite the line segment in terms of "y=mx+b"
;; from standard high school algebra, and use this to solve the problem.
;;

;;
;; A procedure to find the slope of the line segment.
;;
;; Returns the numerical slope of the line when it exists.
;; If the line is vertical and the slope is "infinite", it
;; returns '().
;;
(defn slope [line-segment]
  (let [start (line-segment-start line-segment)
	end (line-segment-end line-segment)]
    (let [dx (- (point-x start) (point-x end))
	  dy (- (point-y start) (point-y end))]
      (if (= dx 0)
	'()
	(* 1.0 (/ dy dx))))))

;;
;; Run some unit tests.
;;
;; Define four points on a square:
;;
(def p1 (make-point 1 1))
(def p2 (make-point 1 -1))
(def p3 (make-point -1 -1))
(def p4 (make-point -1 1))

;;
;; Define the six line segments joining them together:
;;
(def d1 (make-line-segment p1 p2))
(def d2 (make-line-segment p2 p3))
(def d3 (make-line-segment p3 p4))
(def d4 (make-line-segment p4 p1))
(def d5 (make-line-segment p1 p3))
(def d6 (make-line-segment p2 p4))

;;
;; Test the slopes of these line segments:
;;
(slope d1)
;; ==> ()
(slope d2)
;; ==> 0.0
(slope d3)
;; ==> ()
(slope d4)
;; ==> 0.0
(slope d5)
;; ==> 1.0
(slope d6)
;; ==> -1.0

;;
;; So far, so good.
;;
;; Let's make sure that the slope of the line segment is the same,
;; no matter which 'direction' we define the line segment as going in:
;;
(= (slope (make-line-segment p1 p3)) (slope (make-line-segment p3 p1)))
;; ==> true
(= (slope (make-line-segment p2 p4)) (slope (make-line-segment p4 p2)))
;; ==> true
(= (slope (make-line-segment p2 p3)) (slope (make-line-segment p3 p2)))
;; ==> true

;;
;; The test has to be defined slightly differently for "vertical" (i.e.,
;; infinite slope) line segments.
;;
(and (empty? (slope (make-line-segment p1 p2)))
     (empty? (slope (make-line-segment p2 p1))))
;; ==> true

;;
;; Finally, let's test some lines that have differing slopes
;;
(def origin (make-point 0 0))
(def q1 (make-point 1 2))
(def q2 (make-point 1 3))
(def q3 (make-point 2 1))
(def q4 (make-point 3 1))

(slope (make-line-segment origin q1))
;; ==> 2.0
(slope (make-line-segment origin q2))
;; ==> 3.0 
(slope (make-line-segment origin q3))
;; ==> 0.5
(slope (make-line-segment origin q4))
;; ==> 0.33333333333

;;
;; Next we want to determine the y-intercept of the line segment,
;; which would give us the "b" in the y=mx+b formulation.
;;
(defn y-intercept [line-segment]
  (let [p (line-segment-start line-segment)
        m (slope line-segment)]
    (cond (not (= '() m))
          (let [x (point-x p)
                y (point-y p)]
            (- y (* m x))))))

;;
;; Next we want to determine the y-intercept of the line segment,
;; which would give us the "b" in the y=mx+b formulation.
;;
(y-intercept d1)
;; ==> ()
(y-intercept d2)
;; ==> -1.0
(y-intercept d3)
;; ==> ()
(y-intercept d4)
;; ==> 1.0
(y-intercept d5)
;; ==> 0.0 
(y-intercept d6)
;; ==> 0.0

;;
;; If the lines are parallel, they won't intersect!
;;
;; It will be useful to check for this, so let's define it:
;;
(defn parallel? [line-segment-1 line-segment-2]
  (cond (and (= '() (slope line-segment-1)) (= '() (slope line-segment-2))) true
        (and (= '() (slope line-segment-1)) (not (= '() (slope line-segment-2)))) false
        (and (= '() (slope line-segment-2)) (not (= '() (slope line-segment-1)))) false
        :else
        (if (= (slope line-segment-1) (slope line-segment-2))
          true
          false)))

;;
;; Run the unit tests:
;;
(parallel? d1 d2)
;; ==> false
(parallel? d1 d3)
;; ==> true
(parallel? d1 d4)
;; ==> false
(parallel? d1 d5)
;; ==> false
(parallel? d1 d6)
;; ==> false

(parallel? d2 d3)
;; ==> false
(parallel? d2 d4)
;; ==> true
(parallel? d2 d5)
;; ==> false
(parallel? d2 d6)
;; ==> false

(parallel? d3 d4)
;; ==> false
(parallel? d3 d5)
;; ==> false
(parallel? d3 d6)
;; ==> false

(parallel? d4 d5)
;; ==> false
(parallel? d4 d6)
;; ==> false

(parallel? d5 d6)
;; ==> false


(parallel? d1 d1)
;; ==> true
(parallel? d2 d2)
;; ==> true
(parallel? d3 d3)
;; ==> true
(parallel? d4 d4)
;; ==> true
(parallel? d5 d5)
;; ==> true
(parallel? d6 d6)
;; ==> true

;;
;; We're getting close to the final solution.
;;
;; Next let's define a procedure called "intersect" - it will take two
;; line segments as arguments, and determine the point at which the
;; corresponding lines intersect (if they do intersect), or else indicate
;; to the user that the lines are parallel (and hence do not intersect).
;;
(defn intersect [line-segment-1 line-segment-2]
  (if (parallel? line-segment-1 line-segment-2)
    (println "The lines are parallel!")
    (let [m1 (slope line-segment-1)
          m2 (slope line-segment-2)
          b1 (y-intercept line-segment-1)
          b2 (y-intercept line-segment-2)]
      (cond (= '() m1)
            (let [x (point-x (line-segment-start line-segment-1))]
              (make-point x (+ (* m2 x) b2)))
            (= '() m2)
            (let [x (point-x (line-segment-start line-segment-2))]
              (make-point x (+ (* m1 x) b1)))
            :else
            (let [x (/ (- b2 b1) (- m1 m2))]
              (make-point x (+ (* m1 x) b1)))))))

;;
;; Run the unit tests:
;;
(intersect d1 d1)
;; ==> "The lines are parallel!"

;;
;; Makes sense, we expected that.
;;
;; Continuing:
;;
(intersect d1 d2)
;; ==> (1.0 1.0)
(intersect d1 d3)
;; ==> "The lines are parallel!"
(intersect d1 d4)
;; ==> (1.0 1.0)
(intersect d1 d5)
;; ==> (1.0 1.0)
(intersect d1 d6)
;; ==> (1.0 -1.0)

(intersect d2 d3)
;; ==> (-1.0 -1.0)
(intersect d2 d4)
;; ==> "The lines are parallel!"
(intersect d2 d5)
;; ==> (-1.0 -1.0)
(intersect d2 d6)
;; ==> (1.0 -1.0)

(intersect d3 d4)
;; ==> (-1.0 1.0)
(intersect d3 d5)
;; ==> (-1.0 -1.0)
(intersect d3 d6)
;; ==> (-1.0 1.0)

(intersect d4 d5)
;; ==> (1.0 1.0)
(intersect d4 d6)
;; ==> (-1.0 1.0)

(intersect d5 d6)
;; ==> (0.0 0.0)

;;
;; We can determine whether the lines defined by the line segments
;; intersect. But we still don't know whether the line segments themselves
;; actually intersect. To accomplish this, we need to define a few more
;; helper methods.
;;
;; We need to be able to determine whether the x-coordinate for our
;; point of intersection lies between the "left most" and "right most"
;; points of the line segments, and whether the y-coordinate for our
;; point of intersection lies betweeen the "bottom most" and "top most"
;; points of the line segmenets.
;;
;; For instance, a line segment might not necessarily "start" at the
;; "left" and "end" at the "right" (even though this is the intuitive
;; way to define the line segments.
;;
;; We define the following helper methods:
;;

;;
;; Extract the "left-most" point of the line-segment:
;;
(defn left-most-point [line-segment]
  (let [start (line-segment-start line-segment)
        end (line-segment-end line-segment)]
    (if (<= (point-x start) (point-x end))
      start
      end)))

;;
;; Extract the "right-most" point of the line-segment:
;;
(defn right-most-point [line-segment]
  (let [start (line-segment-start line-segment)
        end (line-segment-end line-segment)]
    (if (>= (point-x start) (point-x end))
      start
      end)))

;;
;; Extract the "top-most" point of the line-segment:
;;
(defn top-most-point [line-segment]
  (let [start (line-segment-start line-segment)
        end (line-segment-end line-segment)]
    (if (>= (point-y start) (point-y end))
      start
      end)))

;;
;; Extact the "bottom-most" point of the line-segment:
;;
(defn bottom-most-point [line-segment]
  (let [start (line-segment-start line-segment)
        end (line-segment-end line-segment)]
    (if (<= (point-y start) (point-y end))
      start
      end)))

;;
;; Run some unit tests:
;;
(def line-test-1 (make-line-segment
                  (make-point 0 1)
                  (make-point 2 5)))

(def line-test-2 (make-line-segment
                  (make-point 2 5)
                  (make-point 0 1)))

(slope line-test-1)
;; ==> 2.0
(slope line-test-2)
;; ==> 2.0

(left-most-point line-test-1)