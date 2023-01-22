What is this?
=============

This is an addon for Reblocks Common Lisp framework which allows to gather
metrics in [Prometheus](https://prometheus.io/) format.

How to use
==========

Install the system using quicklisp client and Ultralisp dist:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-prometheus)
```

Then inherit your Reblocks application from PROMETHEUS-APP-MIXIN class:

```
(defapp app
  :subclasses (reblocks-prometheus:prometheus-app-mixin)
  :prefix "/")
```

A new route `/metrics` will be added to serve metrics in Prometheus format.
