<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-40README-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

# reblocks-prometheus - This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format.

<a id="reblocks-prometheus-asdf-system-details"></a>

## REBLOCKS-PROMETHEUS ASDF System Details

* Version: 0.1.0

* Description: This is an addon for Reblocks Common Lisp framework which allows to gather metrics in Prometheus format.

* Licence: Unlicense

* Author: Alexander Artemenko

* Homepage: [https://40ants.com/reblocks-prometheus][0a5b]

* Bug tracker: [https://github.com/40ants/reblocks-prometheus/issues][8225]

* Source control: [GIT][d447]

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

Inherit your Reblocks application from [`prometheus-app-mixin`][db0d] class:

```
(defapp app
  :subclasses (reblocks-prometheus:prometheus-app-mixin)
  :prefix "/")
```
A new route `/metrics` will be added to serve metrics in Prometheus format.

<a id="x-28REBLOCKS-PROMETHEUS-DOCS-2FINDEX-3A-3A-40API-2040ANTS-DOC-2FLOCATIVES-3ASECTION-29"></a>

## API

<a id="x-28REBLOCKS-PROMETHEUS-2FAPP-3APROMETHEUS-APP-MIXIN-20CLASS-29"></a>

### [class](4fe6) `reblocks-prometheus/app:prometheus-app-mixin` ()

A mixin which gathers some stats to report in Prometheus format.

Also, this mixin adds a /metrics slot to the app.

Use [`stats-registry`][b3a2] to access the registry slot.

<a id="x-28REBLOCKS-PROMETHEUS-2FAPP-3ASTATS-REGISTRY-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-PROMETHEUS-2FAPP-3APROMETHEUS-APP-MIXIN-29-29"></a>

### [reader](413d) `reblocks-prometheus/app:stats-registry` (prometheus-app-mixin) (= (make-registry))


[db0d]: #x-28REBLOCKS-PROMETHEUS-2FAPP-3APROMETHEUS-APP-MIXIN-20CLASS-29
[b3a2]: #x-28REBLOCKS-PROMETHEUS-2FAPP-3ASTATS-REGISTRY-20-2840ANTS-DOC-2FLOCATIVES-3AREADER-20REBLOCKS-PROMETHEUS-2FAPP-3APROMETHEUS-APP-MIXIN-29-29
[0a5b]: https://40ants.com/reblocks-prometheus
[d447]: https://github.com/40ants/reblocks-prometheus
[1638]: https://github.com/40ants/reblocks-prometheus/actions
[4fe6]: https://github.com/40ants/reblocks-prometheus/blob/5311c8fb6ee3632847074844b7164e8f87fab02e/src/app.lisp#L31
[413d]: https://github.com/40ants/reblocks-prometheus/blob/5311c8fb6ee3632847074844b7164e8f87fab02e/src/app.lisp#L32
[8225]: https://github.com/40ants/reblocks-prometheus/issues
[df56]: https://prometheus.io/

* * *
###### [generated by [40ANTS-DOC](https://40ants.com/doc/)]
