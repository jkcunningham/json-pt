(require 'json-pt)
(use-package 'json-pt)

(defun encode-test (order)
  (print "----------------------")
  (terpri)
  (json-pt:encode order)
  (terpri))

(encode-test '(:operations (:mode "dont-buy" :env "local")))

(encode-test '(:merchant (:id 145 :coupons nil :password "1234")))

(encode-test '(:sample (:operations (:mode "dont-buy" :env "local"))))

(encode-test '(:items ((:quantity "7" :sku "21857037" :price "11.59"
                        :name "2in x 5in - 2 Mil Flat Poly Bags")
                       (:quantity "2" :upc "12Zas23" :sku "13dtu9" :price "23.21"))))

(encode-test '(:coupons ("6E5918C4" "z2asdf4" "9A5718B4")))

(encode-test '(:merchant (:id 7 :name "drugstore.com"
                          :coupons ("6E5918C4" "z2asdf4" "9A5718B4"))))

(encode-test '(:sample (:operations (:mode "dont-buy" :env "local")
                        :items ((:quantity "7"
                                           :upc ""
                                           :sku "21857037"
                                           :price "11.59"
                                           :name "2in x 5in - 2 Mil Flat Poly Bags")
                                (:quantity "2" :upc "12Zas23" :sku "13dtu9" :price "23.21")))))

(encode-test '(:sample (:operations (:mode "dont-buy" :env "local")
                        :merchant   (:id "13" :name "officemax.com"
                                     :email "Gus.149113@jkcunningham.com"
                                     :password "SVnlNR2{Ifq"))))

(encode-test '(:sample (:operations (:mode "dont-buy" :env "local")
                        :merchant   (:id "13" :name "officemax.com"
                                     :email "Gus.149113@jkcunningham.com"
                                     :password "SVnlNR2{Ifq")
                        :sample (:credit_card
                                 (:credit_card_type_id "2"
                                                       :number "[redacted]-8875"
                                                       :expiration_month "10"
                                                       :expiration_year "2014"
                                                       :code "123"
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

(let ((test '(:SAMPLE
              (:OPERATIONS (:MODE "production" :ENV "staging")
               :ORDER (:MERCHANT_ID 13 :ID 1 :ORDER_ID 1 :BILLING
                       (:FIRST "Eddie" :LAST "Swires" :ADDRESS_1
                               "74928 Louisville Blvd" :ADDRESS_2 "" :SUITE "" :CITY
                               "Stafford Township" :STATE "NJ" :COUNTRY "US" :ZIP_CODE 8050
                               :PLUS_4 "" :PHONE "2366836167")
                       :SHIPPING
                       (:FIRST "Todd" :LAST "Oksen" :ADDRESS_1 "34113 4th Drive"
                               :ADDRESS_2 "" :SUITE "" :CITY "O Fallon" :STATE "MO" :COUNTRY "US"
                               :ZIP 63376 :PLUS_4 "" :PHONE "8422868153")
                       :CREDIT_CARD (:TYPE "visa" :NUMBER "[redacted]-9571" :MONTH "4" :YEAR
                                           2014 :CODE "289" :NAME "Eddie Swires"))
               :MERCHANT (:ID 13 :NAME "officemax.com" :EMAIL "Eddie.248867@jkcunningham.com"
                          :PASSWORD "FB9eU2a42qoT" :coupons ("6E5918C4"))
               :ITEMS-ARRAY ((:QUANTITY 2 :UPC "" :SKU "21720577" :PRICE "24.99" :NAME
                                        "OfficeMax Bevel Wood Laptop Stand, Black" :URL "http://gan.doubleclick.net/gan_click?lid=41000000005217789&pid=21720577&adurl=http%3A%2F%2Fwww.officemax.com%2Foffice-furniture%2Fdesk-accessories-organizers%2Fproduct-prod2410294%3Fcm_mmc%3DPerformics-_-Office%2520Furniture-_-Desk%2520Accessories%2520and%2520Organizers-_-NULL%26ci_src%3D14110944%26ci_sku%3D21720577&usg=AFHzDLsDatktRm7t6reEVuYTBHv7OLMO5w&pubid=21000000000297346")
                             (:QUANTITY 4 :UPC "" :SKU "22374182" :PRICE "8.99" :NAME
                                        "Cosco ACCUSTAMP Round Message Stamp with Microban, Smiley Face, Red"
                                        :URL "http://gan.doubleclick.net/gan_click?lid=41000000005217789&pid=22374182&adurl=http%3A%2F%2Fwww.officemax.com%2Foffice-supplies%2Fstamps-supplies%2Fpre-inked-stamps%2Fproduct-prod3292856%3Fcm_mmc%3DPerformics-_-Office%2520Supplies-_-Stamps%2520and%2520Supplies-_-Pre-Inked%2520Stamps%26ci_src%3D14110944%26ci_sku%3D22374182&usg=AFHzDLvAByVylUwpH0nCqzT8nAcoN3iUVQ&pubid=21000000000297346"))))))

  ;; (setf *json-pprint* nil)
  (setf *json-pprint* t)
  
  (write-json-file test "test.json")
  (let ((pl (read-json-file "test.json")))
    (labels ((ggetf (o key)
               (getf (getf o :sample) key))
             (comp (a b key)
               (format t "~&~(~a~) ~:[failed~;passed~]~%" key (equalp (ggetf a key) (ggetf b key)))))
      (comp test pl :operations)
      (comp test pl :order)
      (comp test pl :merchant)
      (comp test pl :items-array)
      (comp test pl :sample)
      (format t "~&Overall test ~:[failed~;passed~]~%" (equalp test pl)))))

