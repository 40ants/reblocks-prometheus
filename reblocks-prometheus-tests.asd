(defsystem "reblocks-prometheus-tests"
  :author "Alexander Artemenko"
  :license "Unlicense"
  :class :package-inferred-system
  :description "Provides tests for reblocks-prometheus."
  :source-control (:git "https://github.com/40ants/reblocks-prometheus")
  :bug-tracker "https://github.com/40ants/reblocks-prometheus/issues"
  :pathname "t"
  :depends-on ("reblocks-prometheus-tests/core")
  :perform (test-op :after (op c)
                    (symbol-call :rove :run c))  )
