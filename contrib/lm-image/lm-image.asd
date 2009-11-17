(cl:in-package :cl-user)

(defpackage :lm-image-system
  (:use :cl :asdf))
(in-package :lm-image-system)

(defsystem lm-image
    :name "lisp-matrix"
    :version "0.0.1"
    :author "Red Daly <reddaly@cs.stanford.edu>"
    :license "BSD sans advertising clause"
    :description "linear algebra library"
    :long-description "Library for working with images as lisp-matrix
    matrices.  Should be useful for computer vision applications"
    :depends-on (:lisp-matrix
		 :alexandria
		 :png)
    :components
    ((:module
      "src"
      :pathname #p"src/"
      :components
      ((:file "lm-image")    ))))
