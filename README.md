<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# reblocks-prometheus - This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format.

<a id="reblocks-prometheus-asdf-system-details"></a>

## REBLOCKS-PROMETHEUS ASDF System Details

* Description: This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format.
* Licence: Unlicense
* Author: Alexander Artemenko
* Homepage: [https://40ants.com/reblocks-prometheus][0a5b]
* Bug tracker: [https://github.com/40ants/reblocks-prometheus/issues][8225]
* Source control: [GIT][d447]
* Depends on: [40ants-routes][25b9], [prometheus][14fa], [prometheus-gc][8b12], [prometheus.collectors.process][563a], [prometheus.collectors.sbcl][a01b], [prometheus.formats.text][b66b], [reblocks][184b]

[![](https://github-actions.40ants.com/40ants/reblocks-prometheus/matrix.svg?only=ci.run-tests)][1638]

![](http://quickdocs.org/badge/reblocks-prometheus.svg)

This is an addon for Reblocks Common Lisp framework which allows to gather
metrics in [Prometheus][df56] format.

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40INSTALLATION-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Installation

You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-prometheus)
```
<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40USAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## Usage

Add a special metrics route into you're app's route list. Use [`reblocks-prometheus:metrics`][7ea2] macro to define this route.

```
(defapp app
  :prefix "/"
  :routes
  ((reblocks-prometheus:metrics (\"/metrics\" :user-metrics *user-metrics*)))
)
```
A new route `/metrics` will be added to serve metrics in Prometheus format.

<a id="adding-custom-metrics"></a>

### Adding custom metrics

To add business specific metrics, define them as global variables
and then the pass to the [`reblocks-prometheus:metrics`][7ea2] macro like this:

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

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40REBLOCKS-PROMETHEUS-3FPACKAGE-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

### REBLOCKS-PROMETHEUS

<a id="x-28-23A-28-2819-29-20BASE-CHAR-20-2E-20-22REBLOCKS-PROMETHEUS-22-29-20PACKAGE-29"></a>

#### [package](c371) `reblocks-prometheus`

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PROMETHEUS-3FClasses-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Classes

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40REBLOCKS-PROMETHEUS-24METRICS-ROUTE-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### METRICS-ROUTE

<a id="x-28REBLOCKS-PROMETHEUS-3AMETRICS-ROUTE-20CLASS-29"></a>

###### [class](eb8e) `reblocks-prometheus:metrics-route` (route)

**Readers**

<a id="x-28REBLOCKS-PROMETHEUS-3ASTATS-REGISTRY-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-PROMETHEUS-3AMETRICS-ROUTE-29-29"></a>

###### [reader](9557) `reblocks-prometheus:stats-registry` (metrics-route) (= (reblocks-prometheus/app::make-reblocks-metrics-registry))

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40REBLOCKS-PROMETHEUS-24PROMETHEUS-APP-MIXIN-3FCLASS-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

##### PROMETHEUS-APP-MIXIN

<a id="x-28REBLOCKS-PROMETHEUS-3APROMETHEUS-APP-MIXIN-20CLASS-29"></a>

###### [class](da15) `reblocks-prometheus:prometheus-app-mixin` ()

A mixin which gathers some stats to report in Prometheus format.

Also, this mixin adds a /metrics slot to the app.

Use [`stats-registry`][b2a2] to access the registry slot.

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PROMETHEUS-3FFunctions-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Functions

<a id="x-28REBLOCKS-PROMETHEUS-3AMETRICS-REGISTRY-20FUNCTION-29"></a>

##### [function](6692) `reblocks-prometheus:metrics-registry`

Call this function during handler's body to update gauges before metrics will be collected.

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-7C-40REBLOCKS-PROMETHEUS-3FMacros-SECTION-7C-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

#### Macros

<a id="x-28REBLOCKS-PROMETHEUS-3AMETRICS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29"></a>

##### [macro](2324) `reblocks-prometheus:metrics` (path &key name user-metrics) &body handler-body

This macro creates a route of [`metrics-route`][863c] class.

The body passed as `HANDLER-BODY` will be executed each time when metrics are collected.
You can use [`metrics-registry`][e21f] function to access the prometheus metrics registry
from the handler body code.


[7ea2]: #x-28REBLOCKS-PROMETHEUS-3AMETRICS-20-2840ANTS-DOC-2FLOCATIVES-3AMACRO-29-29
[e21f]: #x-28REBLOCKS-PROMETHEUS-3AMETRICS-REGISTRY-20FUNCTION-29
[863c]: #x-28REBLOCKS-PROMETHEUS-3AMETRICS-ROUTE-20CLASS-29
[b2a2]: #x-28REBLOCKS-PROMETHEUS-3ASTATS-REGISTRY-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-PROMETHEUS-3AMETRICS-ROUTE-29-29
[0a5b]: https://40ants.com/reblocks-prometheus
[d447]: https://github.com/40ants/reblocks-prometheus
[1638]: https://github.com/40ants/reblocks-prometheus/actions
[da15]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/app.lisp#L38
[eb8e]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/app.lisp#L78
[9557]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/app.lisp#L79
[6692]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/app.lisp#L87
[2324]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/app.lisp#L94
[c371]: https://github.com/40ants/reblocks-prometheus/blob/60a53b13c465ebfadd46f293a05281964fb92d1e/src/core.lisp#L1
[8225]: https://github.com/40ants/reblocks-prometheus/issues
[df56]: https://prometheus.io/
[25b9]: https://quickdocs.org/40ants-routes
[14fa]: https://quickdocs.org/prometheus
[8b12]: https://quickdocs.org/prometheus-gc
[563a]: https://quickdocs.org/prometheus.collectors.process
[a01b]: https://quickdocs.org/prometheus.collectors.sbcl
[b66b]: https://quickdocs.org/prometheus.formats.text
[184b]: https://quickdocs.org/reblocks

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
