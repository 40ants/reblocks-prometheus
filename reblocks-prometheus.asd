(defsystem "reblocks-prometheus"
  :description "This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format."
  :author "Alexander Artemenko"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-prometheus"
  :source-control (:git "https://github.com/40ants/reblocks-prometheus")
  :bug-tracker "https://github.com/40ants/reblocks-prometheus/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system"
                         ;; This system is required to load
                         ;; prometheus.collectors.process system.
                         ;; we need this until this PR get merged:
                         ;; https://github.com/deadtrickster/prometheus.cl/pull/11
                         "cffi-grovel")
  :pathname "src"
  :depends-on ("reblocks-prometheus/core")
  :in-order-to ((test-op (test-op "reblocks-prometheus-tests"))))


#+sbcl
(register-system-packages "prometheus.collectors.sbcl" '("PROMETHEUS.SBCL"))

(register-system-packages "prometheus.collectors.process" '("PROMETHEUS.PROCESS"))
