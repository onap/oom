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
