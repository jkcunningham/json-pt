(require 'json-pt)
(use-package 'json-pt)

(defun encode-test (order)
  (print "----------------------")
  (terpri)
  (json-pt:encode order)
  (terpri))

(encode-test '(:operations (:mode "dont-buy" :env "local")))

(encode-test '(:merchant (:id 145 :coupons nil :password "1234")))

(encode-test '(:order (:operations (:mode "dont-buy" :env "local"))))

(encode-test '(:items ((:quantity "7" :sku "21857037" :price "11.59"
                        :name "2in x 5in - 2 Mil Flat Poly Bags")
                       (:quantity "2" :upc "12Zas23" :sku "13dtu9" :price "23.21"))))

(encode-test '(:coupons ("6E5918C4" "z2asdf4" "9A5718B4")))

(encode-test '(:merchant (:id 7 :name "drugstore.com"
                          :coupons ("6E5918C4" "z2asdf4" "9A5718B4"))))

(encode-test '(:order (:operations (:mode "dont-buy" :env "local")
                       :items ((:quantity "7"
                                          :upc ""
                                          :sku "21857037"
                                          :price "11.59"
                                          :name "2in x 5in - 2 Mil Flat Poly Bags")
                               (:quantity "2" :upc "12Zas23" :sku "13dtu9" :price "23.21")))))

(encode-test '(:order (:operations (:mode "dont-buy" :env "local")
                       :merchant   (:id "13" :name "officemax.com"
                                    :email "Gus.149113@ronansdoor.com"
                                    :password "SVnlNR2{Ifq"))))

(encode-test '(:order (:operations (:mode "dont-buy" :env "local")
                       :merchant   (:id "13" :name "officemax.com"
                                    :email "Gus.149113@ronansdoor.com"
                                    :password "SVnlNR2{Ifq")
                       :merchant_order (:credit_card
                                        (:credit_card_type_id "2"
                                                              :number "5318039946148875"
                                                              :expiration_month "10"
                                                              :expiration_year "2014"
                                                              :code "510"
                                                              :billing_name "Gus Marvin")
                                        :shipping (:first_name "Pamela"
                                                               :last_name "Goodwin"
                                                               :address_1 "467 Conn Bypass"
                                                               :address_2 ""
                                                               :suite ""
                                                               :city "Gregoryshire"
                                                               :state "MO"
                                                               :country "US"
                                                               :zip_code "30312"
                                                               :zip_plus_4 "1737"
                                                               :phone_number "8728682436")))))

(defparameter *order* '(:ORDER
   (:OPERATIONS (:MODE "dont-buy" :ENV "local") :MERCHENT_ORDER
    (:MERCHANT_ID 13 :ID 1 :ORDER_ID 1 :BILLING
     (:FIRST_NAME "Eddie" :LAST_NAME "Swires" :ADDRESS_1
                  "74928 Louisville Blvd" :ADDRESS_2 "" :SUITE "" :CITY
                  "Stafford Township" :STATE "NJ" :COUNTRY "US" :ZIP_CODE 8050
                  :ZIP_PLUS_4 "" :PHONE_NUMBER "2366836167")
     :SHIPPING
     (:FIRST_NAME "Todd" :LAST_NAME "Oksen" :ADDRESS_1 "34113 4th Drive"
                  :ADDRESS_2 "" :SUITE "" :CITY "O Fallon" :STATE "MO" :COUNTRY "US"
                  :ZIP_CODE 63376 :ZIP_PLUS_4 "" :PHONE_NUMBER "8422868153")
     :CREDIT_CARD
     (:CREDIT_CARD_TYPE_ID "visa" :NUMBER "4003492549571" :EXPIRATION_MONTH
                           "4" :EXPIRATION_YEAR 2014 :CODE "289" :BILLING_NAME "Eddie Swires"))
    :MERCHANT
    (:ID 13 :NAME "officemax.com" :EMAIL "Eddie.248867@ronansdoor.com"
     :PASSWORD "FB9eU2a42qoT"
     :coupons ("6E5918C4"))
    :ITEMS
    ((:QUANTITY 2 :UPC "" :SKU "21720577" :PRICE "24.99" :NAME
                "OfficeMax Bevel Wood Laptop Stand, Black" :URL
                "http://gan.doubleclick.net/gan_click?lid=41000000005217789&pid=21720577&adurl=http%3A%2F%2Fwww.officemax.com%2Foffice-furniture%2Fdesk-accessories-organizers%2Fproduct-prod2410294%3Fcm_mmc%3DPerformics-_-Office%2520Furniture-_-Desk%2520Accessories%2520and%2520Organizers-_-NULL%26ci_src%3D14110944%26ci_sku%3D21720577&usg=AFHzDLsDatktRm7t6reEVuYTBHv7OLMO5w&pubid=21000000000297346")
     (:QUANTITY 4 :UPC "" :SKU "22374182" :PRICE "8.99" :NAME
                "Cosco ACCUSTAMP Round Message Stamp with Microban, Smiley Face, Red"
                :URL
                "http://gan.doubleclick.net/gan_click?lid=41000000005217789&pid=22374182&adurl=http%3A%2F%2Fwww.officemax.com%2Foffice-supplies%2Fstamps-supplies%2Fpre-inked-stamps%2Fproduct-prod3292856%3Fcm_mmc%3DPerformics-_-Office%2520Supplies-_-Stamps%2520and%2520Supplies-_-Pre-Inked%2520Stamps%26ci_src%3D14110944%26ci_sku%3D22374182&usg=AFHzDLvAByVylUwpH0nCqzT8nAcoN3iUVQ&pubid=21000000000297346")))))

(encode-test *order*)


;;; TESTS
(setf *json-pprint* nil)
(write-json-file *order*)


(let (
      ;; (jsonfile "array1.json")
      ;; (jsonfile "array2.json")
      ;; (jsonfile "object.json")
      ;; (jsonfile "items.json")
      ;; (jsonfile "order.4.json")
      ;; (jsonfile "order.5.json")
      (jsonfile "order.json"))
  (with-open-file (js jsonfile)
    (print (decode js))))


================================= DEV
(defparameter *s*
  (with-output-to-string (*standard-output*)
    (encode '(:operations (:mode "testing" :env "local")))))

(print *s*)

(defparameter *print-enable* nil)

(defmacro printnow (fmt &body args)
  `(when *print-enable*
     (fresh-line)
     (princ (format nil ,fmt ,@args))
     (terpri)))

(defun read-char* (js)
  "Returns next non-trivial character from stream JS"
  (let ((c (read-char js nil nil)))
    (case c
      (nil nil)
      ((#\Return #\Newline #\Space #\Tab) (read-char* js))
      (otherwise c))))
  


(progn

  (defun read-until (js termchar &optional cl)
    ;; (printnow "~%-->read-until (~s ~s ~s)" js termchar cl)
    (assert  (streamp js))
    (let ((c (read-char js nil nil)))
      (cond ((null c) nil)
            ((char= c termchar)
             (coerce (reverse cl) 'string))
            (t (read-until js termchar (cons c cl))))))
  
  (defun decode-separator (js sepchar)
    (assert  (streamp js) (js sepchar) "decode-separator(~a ~a)" js sepchar)
    (do ((c (read-char js nil nil) (read-char js nil nil)))
        ((or (char= c sepchar) (null c)) c)))
  
  (defun decode-string (js)
    ;; (printnow "~%-->decode-string (~s)" js)
    (assert  (streamp js) )
    (let ((s (read-until js #\")))
      (printnow "  string=~s" s)
      s))
  
  (defun decode-object (js)
    "Reads an JSON object from stream JS. Assumes the leading '{' has
already been read. Reads the closing '}' from stream before
returning "
    (assert  (streamp js) (js) "js=~s" js)
    (let ((s (decode js)))
      (printnow "  do:s ==> ~s" s)
      (let ((key (intern (string-upcase s) :keyword)))
        (printnow "     key=~s" key)
        (decode-separator js #\:)
        (let ((pair (list key (decode js))))
          (printnow "     pair=~a" pair)
          (ecase (read-char* js)
            (#\,
             (let* ((dob (decode-object js))
                    (cmb (if (json-pt::plist-p dob)
                             (append pair dob)
                             (cons pair dob))))
               (printnow "  object=~s ," cmb)
               cmb))
            (#\}
             (printnow "  do:string:val:~s }" pair)
             pair))))))
  
  (defun decode-array (js)
    (printnow "-->decode-array")
    (assert  (streamp js))
    (let ((el (decode js)))
      (printnow "  element=~s" el)
      ;; What happens next?
      (case (read-char* js)
        (#\,                            ; another element
         (printnow "  ..reading more elements...")
         (let* ((d (decode-array js))
                (ar (cond ((or (stringp d)
                               (json-pt::plist-p d)
                               (numberp d))
                           (list d))
                          (t            ; already an array
                           d)))
                (array (cons el ar)))
           (printnow "  da:ar ~s" ar)
           (printnow "  da:el+ar=~s ," array)
           array))
        (#\]                            ; end of the array
         (printnow "  da:array:~s ]" el)
         (when el (list el)))
        (otherwise
         (break "WTF?:~s" (read js))))))

  (defun decode-atom (js c)
    (printnow "~%-->read-bareword (~a)" c)
    (assert  (streamp js))
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
    (assert  (streamp js) (js) "js=~s" js)
    (let ((c (read-char* js)))
      (case c
        (#\{
         (printnow "    d{ reading object...")
         (decode-object js))
        (#\[
         (printnow "    d[ reading array...")
         (decode-array js))
        (#\"
         (printnow "  ..d:read string...")
         (decode-string js))
        (#\]
         (printnow "    d: array end ]")
         (unread-char #\] js)
         nil)
        (otherwise
         (printnow "  ..d:reading number/true/false/null")
         (decode-atom js c)))))

  (let (
        ;; (jsonfile "array1.json")
        ;; (jsonfile "array2.json")
        ;; (jsonfile "object.json")
        ;; (jsonfile "items.json")
        ;; (jsonfile "order.4.json")
        ;; (jsonfile "order.5.json")
        ;; (jsonfile "order.json")
        (jsonfile "/home/jcunningham/jkcllc/netplenish/np-agent/log/20120603222109_37_145/20120603222102_37_145.order.json"))
    (with-open-file (js jsonfile)
      ;; (decode js)
      (print (decode js))
      )))
