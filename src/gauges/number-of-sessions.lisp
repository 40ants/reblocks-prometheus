(uiop:define-package #:reblocks-prometheus/gauges/number-of-sessions
  (:use #:cl)
  (:import-from #:prometheus
                #:gauge.set
                #:gauge)
  (:import-from #:reblocks/session
                #:get-number-of-anonymous-sessions
                #:get-number-of-sessions
                #:map-sessions)
  (:import-from #:reblocks/page
                #:session-pages))
(in-package #:reblocks-prometheus/gauges/number-of-sessions)


(defclass number-of-sessions-gauge (gauge)
  ()
  (:default-initargs :name "reblocks_sessions_count"
                     :value 0
                     :help "A number of non-anonymous session pages (where :user key is present)."))


(defclass number-of-anonymous-sessions-gauge (gauge)
  ()
  (:default-initargs :name "reblocks_anonymous_sessions_count"
                     :value 0
                     :help "A number of anonymous session pages (where :user key is absent)."))


(defmethod prometheus:collect ((gauge number-of-sessions-gauge) cb)
  (gauge.set gauge
             (get-number-of-sessions))
  (call-next-method))


(defmethod prometheus:collect ((gauge number-of-anonymous-sessions-gauge) cb)
  (gauge.set gauge
             (get-number-of-anonymous-sessions))
  (call-next-method))
