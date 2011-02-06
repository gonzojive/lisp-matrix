(require :cl-who)
(require :cl-markdown)
;(require :external-program)

(defun output-site ()
  (with-open-file (stream "index.html" :direction :output :if-exists :supersede)
    (cl-who:with-html-output (stream stream :prologue t :indent 3)
      (:html
       (:head (:title "lisp-matrix")
              (:link :href "style.css" :rel "stylesheet" :type "text/css")
              (:link :href "favicon.png" :rel "shortcut icon" :type "image/png"))
       (:body
        (:div :class "header"
              (:img :src "icon2.png" :style "float: left; margin: 3px 10px 3px 3px;")
              (:h1 "lisp-matrix"))

        (:div :class "content"
              (who:str (multiple-value-bind (doc str)
                           (cl-markdown:markdown #P"site.markdown" :stream nil)
                         str))
              ;(:p "lisp-matrix is a matrix library for Common Lisp.")

              )
        
        
        (:div :class "footer"
              (:p "Last updated "
                  (multiple-value-bind
                        (second minute hour date month year day-of-week dst-p tz)
                      (get-decoded-time)
                    (who:htm
                     (who:fmt "~A-~2,'0d-~2,'0d"
                              year month date))))))))))

(output-site)
      
