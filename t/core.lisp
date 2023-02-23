(uiop:define-package #:reblocks-prometheus-tests/core
  (:use #:cl)
  (:import-from #:rove
                #:deftest
                #:ok
                #:testing))
(in-package #:reblocks-prometheus-tests/core)


(deftest test-example ()
  (ok t "Replace this test with something useful."))
