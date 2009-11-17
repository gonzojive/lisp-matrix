(cl:defpackage :plot-examples
    (:use :cl-cairo2 :cl-2d :cl-colors :bind :cl :cl-numlib)); :cl-numlib

(in-package :plot-examples)

;;;; I use this macro for convenient creation of PDF files in the
;;;; desired directory.  Make sure that you set *directory* to a path
;;;; that exists and is writable in your system.

(defparameter *directory* "/home/red/www/plot/")

(defmacro with-pdf-frame ((frame filename width height) &body body)
  "Bind frame to a freshly created pdf file, filename is filtered
through make-local-filename."
  (cl-utilities:with-unique-names (context)
    `(let* ((,context (create-pdf-context (concatenate 'string
						       *directory*
						       ,filename)
					  ,width ,height))
            (,frame (as-frame ,context)))
       ;; run body
       (unwind-protect
	    (progn ,@body)
	 ;; close the file
	 (destroy ,context)))))

(defmacro with-png-frame ((frame filename width height) &body body)
  "Bind frame to a freshly created pdf file, filename is filtered
through make-local-filename."
  (alexandria:with-unique-names (context)
    `(let* ((,context (create-png-context ,width ,height
					  (concatenate 'string
						       *directory*
						       ,filename)))
	    (,frame (as-frame ,context)))
       ;; run body
       (unwind-protect
	    (progn ,@body)
	 ;; close the file
	 (destroy ,context)))))
;;;; Plotting random noise with a trend.

(let* ((xs (num-sequence :from 0 :to 100 :by 1))
       (ys (map 'vector (lambda (x)
			  (+ (* 0.5 x) (random 5d0)))
		xs)))
  (with-png-frame (frame "trend.png" 400 300)
    (plot-lines frame xs ys))) 

;;;; Simple sine and cosine plot.  We save the drawing area from the
;;;; first plot, so we can draw on it again.

(with-pdf-frame (frame "sincos.pdf" 400 300)
  (bind ((#(plot-frame legend-frame) (split-frame-vertically frame (spacer) 30))
	 (drawing-area (plot-function plot-frame #'cos (interval-of 0 (* 2 pi))
				      :x-title "x" :y-title "cos(x), sin(x)")))
    (draw-function drawing-area #'sin :line-style +line-dash+)
    (horizontal-legend legend-frame (list +line-solid+ "cos(x)"
					  +line-dash+ "sin(x)"))))


;; image plot
(with-pdf-frame (frame "image.pdf" 400 300)
  (let* ((x (num-sequence :from -40 :to 103 :length 40))
	 (y (num-sequence :from 7 :to 40 :length 40))
	 (image (array-operations:outer-product 
		 x y :function
		 #'(lambda (x y) 
		     (sqrt (+ (square x) (square y)))))))
    (plot-image frame x y image :x-title "x" :y-title "y" 
		:z-title "distance from origin")))


;; two-sided plot
(let* ((xs (num-sequence :from 0 :to 100 :by 1))
       (y1s (map 'vector (lambda (x)
			   (+ (* 0.5 x) (random 5d0)))
		xs))
       (y2s (map 'vector (lambda (x)
			   (+ 100 (* -200 x) (random 1000d0)))
		 xs)))
  (with-pdf-frame (frame "two-sided.pdf" 400 300)
    (plot-lines-two-sided frame xs y1s y2s :x-title "x"
			  :y1-title "one variable"
			  :y2-title "the other variable, different scale (blue)"
			  :line-style2 (modify-style +line-solid+
						     :color +blue+))))

;; how conditions are are handled
(with-pdf-frame (frame "conditions.pdf" 400 300)
  (let ((da (plot-function frame #'(lambda (x) (/ (1- x)))
			   (interval-of 0 2)
			   :y-interval (constantly (interval-of -20 20))
			   :x-title "x" :y-title "1/(x-1)")))
    (draw-vertical-line da 1 +line-dash+)))


;; weighted function

(with-pdf-frame (frame "weighted.pdf" 400 300)
  (let* ((n 500)
	 (xs (num-sequence :from 0 :to 10 :length n))
	 (ys (map 'vector #'(lambda (x) (+ x 8 (random 4.0))) xs))
	 (weights (replicate #'(lambda () (1+ (random 10))) n 'fixnum))
	 (da (plot-simple frame (interval-of 0 10) (interval-of 10 20)
			  :x-title "x" :y-title "y")))
    (draw-symbols da xs ys :weights weights)))

(with-pdf-frame (frame "weighted2.pdf" 400 300)
  (let* ((n 200)
	 (xs (num-sequence :from 0 :to 10 :length n))
	 (ys (map 'vector #'(lambda (x) (+ x 8 (random 4.0))) xs))
	 (weights (replicate #'(lambda () (1+ (random 10))) n 'fixnum))
	 (da (plot-simple frame (interval-of 0 10) (interval-of 10 20)
			  :x-title "x" :y-title "y")))
    (draw-symbols da xs ys :weights weights 
		  :symbol-drawing-function #'symbol-filled-square
		  :color-function (constantly (add-alpha +blue+ 0.5)))))

			  
;; histogram
(let* ((x (replicate (make-poisson-random 10d0) 1200 'fixnum))
       (hist (histogram x)))
  (with-pdf-frame (frame "histogram.pdf" 400 300)
    (plot-histogram frame hist :vertical-lines-p t
		    :fill-color +gray70+
		    :line-style (modify-style +line-solid+ :color +white+
					      :width 2)
		    :y-title "count of draws")))
