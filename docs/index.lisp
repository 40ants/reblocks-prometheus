(uiop:define-package #:reblocks-prometheus-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:reblocks-prometheus-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:import-from #:40ants-doc/autodoc
                #:defautodoc)
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
Add a special metrics route into you're app's route list. Use REBLOCKS-PROMETHEUS:METRICS macro to define this route.

```
(defapp app
  :prefix "/"
  :routes
  ((reblocks-prometheus:metrics (\"/metrics\" :user-metrics *user-metrics*)))
)
```

A new route `/metrics` will be added to serve metrics in Prometheus format.


## Adding custom metrics

To add business specific metrics, define them as global variables
and then the pass to the REBLOCKS-PROMETHEUS:METRICS macro like this:

```
(defparameter *load-average*
  (prometheus:make-gauge :name \"test_load_average\"
                         :help \"Test load average\"
                         :registry nil))

(defparameter *num-users*
  (prometheus:make-counter :name \"test_num_users_created\"
                           :help \"Test num users created after the last metrics collection\"
                           :registry nil))

(defparameter *user-metrics*
  (list *load-average*
        *num-users*))

(defapp app
  :prefix "/"
  :routes
  ((reblocks-prometheus:metrics (\"/metrics\" :user-metrics *user-metrics*)))
)
```

After this, you can change this counter and gauge using methods from prometheus.cl library:

```
(prometheus:gauge.set *load-average* 2)

(prometheus:counter.inc *num-users* :value 1)
(prometheus:counter.inc *num-users* :value 3)
```

and their values will change during subsequent get queries for /metrics page.
""")


(defautodoc @api (:system :reblocks-prometheus))
