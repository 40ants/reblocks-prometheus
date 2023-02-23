(defsystem "reblocks-prometheus-ci"
  :author "Alexander Artemenko"
  :license "Unlicense"
  :class :package-inferred-system
  :description "Provides CI settings for reblocks-prometheus."
  :source-control (:git "https://github.com/40ants/reblocks-prometheus")
  :bug-tracker "https://github.com/40ants/reblocks-prometheus/issues"
  :pathname "src"
  :depends-on ("reblocks-prometheus-ci/ci"))
