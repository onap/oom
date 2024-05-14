(function(window) {
  window["env"] = window["env"] || {};
  window["env"]["keycloak"] = window["env"]["keycloak"] || {};

  // Environment variables
  window["env"]["customStyleEnabled"] = "{{ .Values.env.CUSTOM_STYLE_ENABLED }}";
  window["env"]["keycloak"]["hostname"] = "{{ .Values.env.KEYCLOAK_HOSTNAME }}";
  window["env"]["keycloak"]["realm"] = "{{ .Values.env.KEYCLOAK_REALM }}";
  window['env']['keycloak']['clientId'] = '{{ .Values.env.KEYCLOAK_CLIENT_ID }}';
  window["env"]["loggingEnabled"]= '{{ .Values.env.LOGGING_ENABLED }}';
})(this);
