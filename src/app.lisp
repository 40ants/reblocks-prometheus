(uiop:define-package #:reblocks-prometheus/app
  (:use #:cl)
  (:import-from #:prometheus
                #:collector
                #:make-registry)
  (:import-from #:prometheus.formats.text
                #:marshal)
  #+sbcl
  (:import-from #:prometheus.sbcl
                #:make-memory-collector
                #:make-threads-collector)
  (:import-from #:prometheus.process
                #:make-process-collector)
  (:import-from #:log4cl-extras/error
                #:with-log-unhandled)
  (:import-from #:reblocks/session)
  (:import-from #:reblocks/routes)
  (:import-from #:routes)
  (:import-from #:reblocks/variables
                #:*current-app*)
  (:import-from #:reblocks-prometheus/core
                #:prometheus-app-mixin
                #:stats-registry
                #:metrics
                #:metrics-route
                #:metrics-registry)
  (:import-from #:reblocks-prometheus/gauges/number-of-pages
                #:number-of-pages-gauge)
  (:import-from #:reblocks-prometheus/gauges/number-of-sessions
                #:number-of-sessions-gauge
                #:number-of-anonymous-sessions-gauge)
  (:import-from #:prometheus-gc
                #:make-gc-collector)
  (:import-from #:40ants-routes/defroutes)
  (:import-from #:40ants-routes/vars)
  (:import-from #:40ants-routes/handler
                #:call-handler))
(in-package #:reblocks-prometheus/app)


(defclass prometheus-app-mixin ()
  ()
  (:documentation "A mixin which gathers some stats to report in Prometheus format.

Also, this mixin adds a /metrics slot to the app.

Use STATS-REGISTRY to access the registry slot."))


(defmethod initialize-instance :after ((app prometheus-app-mixin) &rest args)
  (declare (ignore args))

  (error "PROMETHEUS-APP-MIXIN class is deprecated. Use new Reblocks routing mechanism and REBLOCKS-PROMETHEUS:METRICS macro."))


(defun make-reblocks-metrics-registry ()
  (let* ((registry (make-registry)))
    #+sbcl
    (progn
      ;; Memory collector causes application hangs on SBCL:
      ;; https://github.com/deadtrickster/prometheus.cl/issues/13
      ;; This is why it was turned off:
      ;; (make-memory-collector :registry registry)
      (make-threads-collector :registry registry)
      (make-gc-collector :registry registry))

    ;; /proc/* files are available only on Linux
    #+linux
    (make-process-collector :registry registry)

    (make-instance 'number-of-pages-gauge
                   :registry registry)
    (make-instance 'number-of-sessions-gauge
                   :registry registry)
    (make-instance 'number-of-anonymous-sessions-gauge
                   :registry registry)
    
    (values registry)))


(defclass metrics-route (40ants-routes/route:route)
  ((registry :initform (make-reblocks-metrics-registry)
             :reader stats-registry)))


(serapeum:defvar-unbound *current-registry*
  "This var will be bound to the current prometheus registry during the REBLOCKS/ROUTES:SERVE generic-function call.")


(defun metrics-registry ()
  "Call this function during handler's body to update gauges before metrics will be collected."
  (unless (boundp '*current-registry*)
    (error "This function should be called only during REBLOCKS/ROUTES:SERVE generic-function execution."))
  (values *current-registry*))


(defmacro metrics ((path &key name user-metrics) &body handler-body)
  "This macro creates a route of METRICS-ROUTE class.

   The body passed as HANDLER-BODY will be executed each time when metrics are collected.
   You can use METRICS-REGISTRY function to access the prometheus metrics registry
   from the handler body code."
  `(let ((route (40ants-routes/defroutes:get (,path :name ,name :route-class metrics-route)
                  ,@handler-body)))
     (loop for metric in ,user-metrics
           do (prometheus:register metric
                                   (stats-registry route)))
     (values route)))


(defmethod reblocks/routes:serve ((route metrics-route) env)
  "Returns a text document with metrics in Prometheus format.

   To add your own metrics, add a :BEFORE method to this method. In this :BEFORE
   method you can update gauge metrics."
  (let* ((*current-registry* (stats-registry route)))
    ;; Now we'll let chance to a custom user code defined as handler-body of METRICS macro
    ;; to modify gauges and counters:
    (call-handler)

    ;; And finally, serialize metrics to response:
    (list 200
          (list :content-type "text/plain")
          (list (marshal (stats-registry route))))))


(defmethod reblocks/routes:serve :after ((route metrics-route) env)
  ;; Monitoring system does not keep cookies, so to not pollute
  ;; session cache with sessions where only metrics page was fetched,
  ;; we'll drop it right after the serving metrics:
  (reblocks/session:expire))
