(defpackage :lm-image
    (:use :lisp-matrix :common-lisp :alexandria))

(in-package :lm-image)

(defmacro ensure-stream ((stream-var thing &key (element-type ''(unsigned-byte 8)) ) &body body)
  (once-only (thing)
    `(typecase ,thing
       (stream (let ((,stream-var ,thing))
		 ,@body))
       ((or string pathname)
	  (with-open-file (,stream-var ,thing :element-type ,element-type)
	    ,@body))
       (t (error "Invalid, non-streamy object ~S" ,thing)))))
  
(defun infer-image-encoding-from-path (pathname)
  (let ((str-type (pathname-type pathname)))
    (cond
      ((member str-type '("jpg" "jpeg") :test #'equalp) :jpeg)
      ((member str-type '("png") :test #'equalp) :png)
      (t nil))))

(defun image-to-matrix (input &key image-encoding )
  (setf image-encoding (or image-encoding
			   (when (or (stringp input) (pathname input))
			     (infer-image-encoding-from-path (pathname input)))))
  (ensure-stream (stream input)
    (case image-encoding 
      (:jpeg
	 (jpeg:decode-stream stream))
      (:png
	 (png:decode stream))
      (t "No decoding scheme for image encoding ~A" image-encoding))))
  