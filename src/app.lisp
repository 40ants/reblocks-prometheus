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
  (:import-from #:reblocks/variables
                #:*current-app*)
  (:import-from #:reblocks-prometheus/gauges/number-of-pages
                #:number-of-pages-gauge)
  (:import-from #:reblocks-prometheus/gauges/number-of-sessions
                #:number-of-sessions-gauge
                #:number-of-anonymous-sessions-gauge)
  (:import-from #:prometheus-gc
                #:make-gc-collector)
  (:export #:prometheus-app-mixin
           #:stats-registry))
(in-package #:reblocks-prometheus/app)


(defclass prometheus-app-mixin ()
  ((registry :initform (make-registry)
             :reader stats-registry))
  (:documentation "A mixin which gathers some stats to report in Prometheus format.

Also, this mixin adds a /metrics slot to the app.

Use STATS-REGISTRY to access the registry slot."))



(defmethod initialize-instance :after ((app prometheus-app-mixin) &rest args)
  (declare (ignore args))

  (let* ((registry (stats-registry app)))
  
    #+sbcl
    (progn 
      (make-memory-collector :registry registry)
      (make-threads-collector :registry registry)
      (make-gc-collector :registry registry))
  
    (make-process-collector :registry registry)

    (make-instance 'number-of-pages-gauge
                   :registry registry)
    (make-instance 'number-of-sessions-gauge
                   :registry registry)
    (make-instance 'number-of-anonymous-sessions-gauge
                   :registry registry)


    (let* ((route (make-instance 'reblocks/routes:route
                                 :template
                                 (routes:parse-template "/metrics")
                                 :handler '/metrics
                                 :content-type "text/plain"))
           (app-class-name (typecase app
                             (symbol app)
                             (t (type-of app)))))
      ;; TODO: this place should be refactored when I've refactor
      ;; the way how application routes are defined in Reblocks
      (setf (get '/metrics :route) route)
      (pushnew '/metrics (get app-class-name :route-handlers)))))


(defvar *app* nil)


(defgeneric serve-stats (app)
  (:documentation "Should return a string with metrics in Prometheus format.")
  (:method :after ((app prometheus-app-mixin))
    (setf *app* app)
    (reblocks/session:expire))
  (:method ((app prometheus-app-mixin))
    (marshal (stats-registry app))))


(defun /metrics ()
  (with-log-unhandled ()
    (serve-stats *current-app*)))
