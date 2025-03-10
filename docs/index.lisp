(uiop:define-package #:reblocks-prometheus-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:reblocks-prometheus
                #:stats-registry
                #:prometheus-app-mixin)
  (:import-from #:reblocks-prometheus-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:export #:@index
           #:@readme
           #:@changelog))
(in-package #:reblocks-prometheus-docs/index)

(in-readtable pythonic-string-syntax)


(defmethod docs-config ((system (eql (asdf:find-system "reblocks-prometheus-docs"))))
  ;; 40ANTS-DOC-THEME-40ANTS system will bring
  ;; as dependency a full 40ANTS-DOC but we don't want
  ;; unnecessary dependencies here:
  #+quicklisp
  (uiop:symbol-call :ql :quickload
                    "40ants-doc-theme-40ants")
  #-quicklisp
  (asdf:load-system "40ants-doc-theme-40ants")
  
  (list :theme
        (find-symbol "40ANTS-THEME"
                     (find-package "40ANTS-DOC-THEME-40ANTS"))))


(defsection @index (:title "reblocks-prometheus - This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format."
                    :ignore-words ("JSON"
                                   "HTTP"
                                   "TODO"
                                   "Unlicense"
                                   "REPL"
                                   "GIT"))
  (reblocks-prometheus system)
  "
[![](https://github-actions.40ants.com/40ants/reblocks-prometheus/matrix.svg?only=ci.run-tests)](https://github.com/40ants/reblocks-prometheus/actions)

![Quicklisp](http://quickdocs.org/badge/reblocks-prometheus.svg)

This is an addon for Reblocks Common Lisp framework which allows to gather
metrics in [Prometheus](https://prometheus.io/) format.

"
  (@installation section)
  (@usage section)
  (@api section))


(defsection-copy @readme @index)


(defsection @installation (:title "Installation")
  """
You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-prometheus)
```
""")


(defsection @usage (:title "Usage"
                    :ignore-words ("ASDF:PACKAGE-INFERRED-SYSTEM"
                                   "ASDF"
                                   "40A"))
  """
Inherit your Reblocks application from PROMETHEUS-APP-MIXIN class:

```
(defapp app
  :subclasses (reblocks-prometheus:prometheus-app-mixin)
  :prefix "/")
```

A new route `/metrics` will be added to serve metrics in Prometheus format.
""")


(defsection @api (:title "API")
  (prometheus-app-mixin class)
  (stats-registry (reader prometheus-app-mixin)))
