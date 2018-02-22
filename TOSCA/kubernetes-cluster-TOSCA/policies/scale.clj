;;;; ============LICENSE_START==========================================
;;;; ===================================================================
;;;; Copyright (c) 2017 AT&T
;;;;
;;;; Licensed under the Apache License, Version 2.0 (the "License");
;;;; you may not use this file except in compliance with the License.
;;;; You may obtain a copy of the License at
;;;;
;;;;         http://www.apache.org/licenses/LICENSE-2.0
;;;;
;;;; Unless required by applicable law or agreed to in writing, software
;;;; distributed under the License is distributed on an "AS IS" BASIS,
;;;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;;;; See the License for the specific language governing permissions and
;;;; limitations under the License.
;;;;============LICENSE_END============================================

(where (service #"{{service_selector}}")
  #(info "got event: " %)

  (where (not (expired? event))
    (moving-time-window {{moving_window_size}}
      (fn [events]
        (let [
               hostmap (atom {})
               hostcnt (atom {})
             ]
          (do
            (doseq [m events]
              (if (nil? (@hostmap (m :host)))
                (do
                  (swap! hostmap assoc (m :host) (m :metric))
                  (swap! hostcnt assoc (m :host) 1)
                )
                (do
                  (swap! hostmap assoc (m :host) (+ (m :metric) (@hostmap (m :host))))
                  (swap! hostcnt assoc (m :host) (inc (@hostcnt (m :host))))
                )
              )
            )
            (doseq [entry @hostmap]
              (swap! hostmap assoc (key entry) (/ (val entry) (@hostcnt (key entry))))
            )

            (let
              [ hostcnt (count @hostmap)
                conns (/ (apply + (map (fn [a] (val a)) @hostmap)) hostcnt)
                cooling (not (nil? (riemann.index/lookup index "scaling" "suspended")))]

              (do
                (info "cooling=" cooling " scale_direction={{scale_direction}} hostcnt=" hostcnt " scale_threshold={{scale_threshold}} conns=" conns)
                (if (and (not cooling) ({{scale_direction}} hostcnt {{scale_limit}}) ({{scale_direction}} {{scale_threshold}} conns))
                  (do
                    (info "=== SCALE ===" "{{scale_direction}}")
                    (process-policy-triggers {})
                    (riemann.index/update index {:host "scaling" :service "suspended" :time (unix-time) :description "cooldown flag" :metric 0 :ttl {{cooldown_time}} :state "ok"})
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
