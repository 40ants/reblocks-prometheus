(defsystem "reblocks-prometheus"
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("reblocks-prometheus/core"))


#+sbcl
(register-system-packages "prometheus.collectors.sbcl" '("PROMETHEUS.SBCL"))

(register-system-packages "prometheus.collectors.process" '("PROMETHEUS.PROCESS"))
