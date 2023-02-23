(defsystem "reblocks-prometheus-docs"
  :author "Alexander Artemenko"
  :license "Unlicense"
  :class :package-inferred-system
  :description "Provides documentation for reblocks-prometheus."
  :source-control (:git "https://github.com/40ants/reblocks-prometheus")
  :bug-tracker "https://github.com/40ants/reblocks-prometheus/issues"
  :pathname "docs"
  :depends-on ("reblocks-prometheus"
               "reblocks-prometheus-docs/index"))
