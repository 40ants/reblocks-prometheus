(uiop:define-package #:reblocks-prometheus/gauges/number-of-pages
  (:use #:cl)
  (:import-from #:prometheus
                #:gauge.set
                #:gauge)
  (:import-from #:reblocks/session
                #:map-sessions)
  (:import-from #:reblocks/page
                #:session-pages))
(in-package #:reblocks-prometheus/gauges/number-of-pages)


(defclass number-of-pages-gauge (gauge)
  ()
  (:default-initargs :name "reblocks_pages_count"
                     :value 0
                     :help "A number of nonexpired session pages."))


(defmethod prometheus:collect ((gauge number-of-pages-gauge) cb)
  (let ((value 0))
    (flet ((count-pages (pages)
             (when pages
               (incf value (hash-table-count pages)))
             ;; It is important to return value as is:
             (list pages)))
      (declare (dynamic-extent #'count-pages))
      
      (map-sessions #'count-pages 'session-pages))
    
    (gauge.set gauge value)
    
    (call-next-method)))
