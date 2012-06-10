
(in-package :cl-user)

(defpackage #:json-pt
  (:use :cl)
  (:export
   #:*json-pprint*
   #:encode
   #:write-json-file
   #:decode
   #:read-json-file
   ))

