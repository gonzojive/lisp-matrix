Lisp-Matrix is a reasonably modern, flexible system for numeric
algebra in Lisp.  At the lowest level, LAPACK performs the heavy
numerical computation through a foreign function interface (CFFI).
There is also a suite of lisp routines that provide the sort of simple
matrix manipulation used frequently in MATLAB.

## Download

Please use the
[github repository](https://github.com/blindglobe/lisp-matrix) to
download and install manually:

    git clone git://github.com/blindglobe/lisp-matrix.git
    
Note that you will also need the following dependencies:

* [cffi](http://common-lisp.net/project/cffi/)
* [cl-utilities](http://common-lisp.net/project/cl-utilities/)
* [ffa](https://github.com/blindglobe/ffa-lisp-matrix)
* [lift](http://common-lisp.net/project/lift/)
* [org.middleangle.foreign-numeric-vector](https://github.com/blindglobe/fnv)
* [org.middleangle.cl-blapack](https://github.com/blindglobe/cl-blapack)

## Mailing list

[lisp-matrix-devel](http://common-lisp.net/cgi-bin/mailman/listinfo/lisp-matrix-devel)
is the main mailing list.  Post all questions, comments, and the like
to this list.  You can also chart progress by
[following the project on github](https://github.com/blindglobe/lisp-matrix).
