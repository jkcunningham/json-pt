(in-package :json-pt)

(defparameter *json-pprint* t "Enables pretty-printed output for encode when not NIL.")
(defparameter *json-debug* nil "Writes out useful debugging data in recursions when not NIL. ")

(defun plist-p (l)
  "Returns T if L is a plist (list with alternating keyword elements). "
  (cond ((null l) t)
        ((not (listp l)) nil)
        ((and (cdr l) (keywordp (car l)))
         (plist-p (cddr l)))))

;;; Encoder
;;; -------

(defun write-n (n &optional (c #\Space))
  (when *json-pprint*
    (dotimes (i n) (princ c))))

(defun freshline (n)
  (when *json-pprint*
    (fresh-line)
    (write-n n)))

(defmacro make-object-handler (name oc cc fcn)
  `(defun ,(intern (string-upcase name)) (pl &optional (n 0))
     (writed ,(format nil "~a=>" name) pl)
     (when pl
       (princ ,oc)
       (freshline (+ n 2))
       (,fcn pl (+ n 2))
       (freshline n)
       (princ ,cc)
       'done)))

(defun writed (lbl val)
  "Diagnostic write function (requires *json-debug* T)"
  (when *json-debug*
    (freshline 2)
    (princ lbl)
    (princ val)
    (terpri)))

(defun keystr (k)
  (format t "\"~(~a~)\":" k))

(defun encode-pairs (pl &optional (n 0))
  (when pl
    (writed "encode-pairs=>" pl)
    (keystr (first pl))
    (encode (second pl) n)
    (when (third pl)
      (princ ",") (freshline n))
    (encode-pairs (cddr pl) n)))

(defun encode-array-el (pl &optional (n 0))
  (writed "encode-array-el=>" pl)
  (when pl
    (encode (car pl) n)
    (when (cdr pl)
      (princ ",") (freshline n))
    (encode-array-el (cdr pl) n)))

(make-object-handler "encode-array" "[" "]" encode-array-el)
(make-object-handler "encode-list" "{" "}" encode-pairs)

(defun encode (pl &optional (n 0))
  "Encodes plist tree PL into a json representation. Will
pretty-print structure if *JSON-PPRINT* is true. Redirect
*standard-output* to write to file. "
  (writed "encode=>" pl)
  (cond ((null pl)
         (princ "[]")) ;; <=== might want null here instead
        ((stringp pl)
         (prin1 pl))
        ((atom pl)
         (prin1 (write-to-string pl)))
        ((plist-p pl)
         (encode-list pl n))
        (t 
         (encode-array pl n))))

(defun write-json-file (sexp file)
  "Writes a json-format file to FILE out of plist tree SEXP."
  (with-open-file (*standard-output* file :direction :output :if-exists :supersede)
    (encode sexp)))


;;; Decoder
;;; -------

(defmacro printnow (fmt &body args)
  "Used in debugging decoder recursions. Only writes if *json-debug*
isn't NIL. See test-json.lisp"
  `(when *json-debug*
     (fresh-line)
     (princ (format nil ,fmt ,@args))
     (terpri)))

(defun read-char* (js)
  "Helper function for DECODE function. Returns next non-trivial
character from stream JS"
  (let ((c (read-char js nil nil)))
    (case c
      (nil nil)
      ((#\Return #\Newline #\Space #\Tab) (read-char* js))
      (otherwise c))))

(defun read-until (js termchar &optional cl)
  "Helper function for DECODE function. Reads characters from stream
until TERMCHAR and returns string."
  (let ((c (read-char js nil nil)))
    (cond ((null c) nil)
          ((char= c termchar)
           (coerce (reverse cl) 'string))
          (t (read-until js termchar (cons c cl))))))
  
(defun decode-separator (js sepchar)
  "Helper function for DECODE function. "
  (do ((c (read-char js nil nil) (read-char js nil nil)))
      ((or (char= c sepchar) (null c)) c)))
  
(defun decode-string (js)
  "Helper function for DECODE function. "
  (read-until js #\"))
  
(defun decode-object (js)
  "Reads an JSON object from stream JS. Assumes the leading '{' has
already been read. Reads the closing '}' from stream before
returning "
  (let ((s (decode js)))
    (let ((key (intern (string-upcase s) :keyword)))
      (decode-separator js #\:)
      (let ((pair (list key (decode js))))
        (ecase (read-char* js)
          (#\, (let ((dob (decode-object js)))
                 (if (plist-p dob)
                     (append pair dob)
                     (cons pair dob))))
          (#\} pair))))))
  
(defun decode-array (js)
  "Helper function for DECODE function. "
  (let ((el (decode js)))
    (ecase (read-char* js)
      (#\,                              ; another element
       (let ((d (decode-array js)))
         (cons el (if (or (stringp d)
                          (json-pt::plist-p d)
                          (numberp d))
                      (list d)
                      d))))
      (#\]                              ; end of the array
       (when el (list el))))))

(defun decode-atom (js c)
  "Helper function for DECODE function. "
  (labels ((nextchar ()
             (let ((c (read-char js nil nil)))
               (case c
                 ((#\Return #\Linefeed #\Newline)
                  nil)
                 ((#\, #\} #\])
                  (unread-char c js)
                  nil)
                 (otherwise
                  (cons c (nextchar)))))))
    (let* ((a (coerce (cons c (nextchar)) 'string))
           (ra (read-from-string a)))
      (cond ((numberp ra) ra)
            ((member a '("null" "false") :test #'string=) nil)
            ((string= a "true") T)
            (t a)))))

(defun decode (js)
  "Reads JSON structure from character stream JS and converts it to
SEXP. See http://json.org for definition of JSON structure. "
  (let ((c (read-char* js)))
    (case c
      (#\{
       (decode-object js))
      (#\[
       (decode-array js))
      (#\]
       (unread-char #\] js)
       nil)
      (#\"
       (decode-string js))
      (otherwise
       (decode-atom js c)))))

(defun read-json-file (file)
  "Reads and returns a plist tree representing a JSON structure from
  FILE. "
  (with-open-file (js file) (decode js)))


