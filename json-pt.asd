;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-
;;;; netplenish.asd

(in-package :cl-user)

(defparameter *json-pt-directory*
  (make-pathname :name nil :type nil :version nil
                 :defaults (parse-namestring *load-truename*)))

(asdf:defsystem #:json-pt
  :perform (asdf:load-op :after (op json-pt) (pushnew :json-pt *features*))
  :serial t
  :components ((:file "package")
               (:file "json-pt")))

