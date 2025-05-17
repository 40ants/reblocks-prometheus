(uiop:define-package #:reblocks-prometheus-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:reblocks-prometheus-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "API"
                              "HTTP"))
  (0.2.0 2025-04-24
         "
# Backward incompatible changes

* Now library depends on recent changes to Reblock's routing.
* Also, API has changed. Instead of adding a class mixin, you need to add a custom route to the app's routes.
  Read more about new usage pattern in REBLOCKS-PROMETHEUS-DOCS/INDEX::@USAGE section.
* Mixin class now is deprecated and will not work. It's instantiation results in the error.
  In the next version it will be removed completely.
")
  (0.1.0 2023-02-05
         "* Initial version."))
