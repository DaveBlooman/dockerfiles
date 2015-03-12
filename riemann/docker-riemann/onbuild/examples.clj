; -*- mode: clojure; -*-
; vim: filetype=clojure
(use 'riemann.slack)

(load-plugins)
(require '[org.spootnik.riemann.thresholds :refer [threshold-check]])

; Listen on the local interface over TCP (5555), UDP (5555), and websockets
; (5556)
(let [host "0.0.0.0"]
  (tcp-server {:host host})
  (udp-server {:host host})
  (ws-server  {:host host}))

; Expire old events from the index every 5 seconds.
(periodically-expire 10)

;The following code is based on the code sample in this pull request comment on Github:
; https://github.com/aphyr/riemann/issues/411#issue-36716498

(require '[riemann.common :refer [event]])
(require 'capacitor.core)
(require 'capacitor.async)
(require 'clojure.core.async)

;Create an asynchronous InfluxDB client using the capacitor library:
(defn make-async-influxdb-client [opts]
    (let [client (capacitor.core/make-client opts)
      ;Make a channel to buffer influxdb events
      events-in (capacitor.async/make-chan)
      ;Make a channel to collect influxdb responses (ignored, really)
      resp-out (capacitor.async/make-chan)]
      ;Start the run loop with a batch size of max 100 events and max 10 seconds
      (capacitor.async/run! events-in resp-out client 100 10000)
        (fn [series payload]
          (let [p (merge payload {
            :series series
            ;; s to ms
            :time   (* 1000 (:time payload))})]
            (clojure.core.async/put! events-in p)))))


(def slack-webhook-uri "slack URL")

(def sidebar-color {"ok" "good" "expired" "warning" "error" "danger"})

(def slack-webhook-uri)
(def sl (slack {:webhook_uri slack-webhook-uri} {:formatter (fn [e]
                                                              {:attachments [{:color (sidebar-color (:state e))
                                                                              :text (str "*" (:service e) "*" ": "
                                                                                         (clojure.string/upper-case (:state e))
                                                                                         "\n" (:description e))
                                                                              :mrkdwn_in [:text]}]})}))



(streams
 (where (service "deploy")
       (changed-state
         sl


(streams
 (where
 (and (service #"^deploy.*")
       (> metric 1)
       sl)))

(let [index (smap (threshold-check thresholds)
                   (tap :index (index))
                   sl)])

(streams
    (where (service #"^deploy.*")
      (split(< metric 2)(with :state "ok" index)
            (> metric 10)(with :state "error" index)))
    (changed-state
           sl))



(streams
  (smap (threshold-check thresholds)
    (where (service #"^deploy.*")
    (changed-state
       sl))))

    (where (service "chartbeat.top.desktop")
    (changed-state
       sl)))


(def write-influxdb-async (make-async-influxdb-client {
  :host "192.168.59.103"
  :port 8086
  :username "root"
  :password "root"
  :db "riemann"
  }))

(let [index (index)]

 (streams
     (where (and (not (.contains service "phabricator"))
                 (or (state "critical")
                     (state "warning"))
       ) tell-ops))

  ;Inbound events will be passed to the functions that come after (streams...
  (streams
    ;This is one function. Index all events immediately:
    index

    ;Asynchronous InfluxDB writer; this creates series names automatically by combining the hostname and service n                                                                ame from the event
    ;passed into it:
    (fn [event]
      (let [series (format "%s.%s" (:host event) (:service event))]
        (write-influxdb-async series {
          :host (:host event)
          :time  (:time event)
          :value (:metric event)
          :name (:service event)})))

    ;Log everything to the log file defined above in (logging/init...
    ;Commenting it out since we don't need it right now,
    ;but it's nice to have at hand in case we need to debug things later:
    ;#(info %)
    ))
