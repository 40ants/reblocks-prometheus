(uiop:define-package #:reblocks-prometheus
  (:use #:cl)
  (:nicknames #:reblocks-prometheus/core)
  (:import-from #:reblocks-prometheus/app
                #:prometheus-app-mixin)
  (:export #:prometheus-app-mixin))
(in-package #:reblocks-prometheus)

