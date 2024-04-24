{{/*
# Copyright © 2024 Tata Communication Limited (TCL), Deutsche Telekom AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

{{/*
Renders a value that contains template.
Usage:
{{ include "auth.realm" ( dict "dot" . "realm" .Values.path.to.realm) }}
*/}}
{{- define "auth.realm" -}}
{{- $dot := default . .dot -}}
{{- $realm := (required "'realm' param, set to the specific service, is required." .realm) -}}
realm: {{ $realm.name }}
{{ if $realm.displayName }}displayName: {{ $realm.displayName }}{{ end }}
id: {{ $realm.name }}
accessTokenLifespan: 1900
registrationAllowed: false
resetPasswordAllowed: true
enabled: true
{{ if $realm.themes }}
{{   if $realm.themes.login }}loginTheme: {{ $realm.themes.login }}{{ end }}
{{   if $realm.themes.admin }}adminTheme: {{ $realm.themes.admin }}{{ end }}
{{   if $realm.themes.account }}accountTheme: {{ $realm.themes.account }}{{ end }}
{{   if $realm.themes.email }}emailTheme: {{ $realm.themes.email }}{{ end }}
{{- end }}
{{- if $realm.accessControl }}
{{ include "auth._roles" $realm }}
{{- end }}
{{ include "auth._clients" (dict "dot" $dot "realm" $realm) }}
{{ include "auth._clientScopes" $realm }}
{{ include "auth._defaultClientScopes" $realm }}
{{ include "auth._groups" $realm }}
{{ include "auth._users" $realm }}
{{ include "auth._identity" $realm }}
{{ include "auth._identityMapper" $realm }}
{{ include "auth._attributes" (dict "dot" $dot "realm" $realm) }}
{{- end -}}

{{/*
Renders the roles section in a realm.
Usage:
{{ include "auth._roles" ( dict "dot" .Values) }}
*/}}
{{- define "auth._roles" -}}
{{- $realm := default . .dot -}}
roles:
  realm:
    {{- range $index, $role := $realm.accessControl.assignableRoles }}
    - name: "{{ $role.name }}"
      description: "{{ $role.description }}"
      {{- if $role.associatedAccessRoles }}
      composite: true
      composites:
        client:
          {{- range $key, $accessRole := $realm.accessControl.accessRoles }}
          {{ $client := index $realm.clients $key -}}
          {{ $client.clientId }}:
            {{- range $index2, $associatedRole := $role.associatedAccessRoles }}
            - {{ $associatedRole }}
            {{- end }}
          {{- end }}
      {{- else }}
      composite: false
      {{- end }}
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
    {{- end }}
    - name: "user"
      composite: false
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
    - name: "admin"
      composite: false
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
    - name: "offline_access"
      description: "${role_offline-access}"
      composite: false
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
    - name: "uma_authorization"
      description: "${role_uma_authorization}"
      composite: false
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
    - name: "default-roles-{{ $realm.name }}"
      description: "${role_default-roles}"
      composite: true
      composites:
        realm:
          - "offline_access"
          - "uma_authorization"
        client:
          account:
            - "view-profile"
            - "manage-account"
      clientRole: false
      containerId: "{{ $realm.name }}"
      attributes: {}
  {{- if $realm.accessControl.accessRoles }}
  client:
    {{- range $key, $accessRole := $realm.accessControl.accessRoles }}
    {{ $client := index $realm.clients $key -}}
    {{ $client.clientId }}:
    {{- range $index, $role := get $realm.accessControl.accessRoles $key }}
      - name: "{{ $role.name }}"
        description: "Allows to perform {{ $role.methodsAllowed }} operations for {{ $role.name }} component"
        composite: false
        clientRole: false
        containerId: "{{ $client.clientId }}"
        attributes: {}
    {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
Renders the clients section in a realm.
Usage:
{{ include "auth._clients" ( dict "dot" . "realm" $realm ) }}
*/}}
{{- define "auth._clients" -}}
{{- $dot := default . .dot -}}
{{- $realm := (required "'realm' param, set to the specific service, is required." .realm) -}}
clients:
  {{- range $index, $client := $realm.clients }}
  - clientId: "{{ $client.clientId }}"
    name: "{{ $client.name }}"
    description: "{{ default "" $client.description }}"
    {{- if $client.rootUrl }}
    rootUrl: {{ tpl $client.rootUrl $dot }}
    {{- else }}
    rootUrl: ""
    {{- end }}
    {{- if $client.adminUrl }}
    adminUrl: {{ tpl $client.adminUrl $dot }}
    {{- else }}
    adminUrl: ""
    {{- end }}
    {{- if $client.baseUrl }}
    baseUrl: {{ tpl $client.baseUrl $dot }}
    {{- else }}
    baseUrl: ""
    {{- end }}
    surrogateAuthRequired: false
    enabled: true
    alwaysDisplayInConsole: false
    clientAuthenticatorType: "client-secret"
    secret: "{{ default "" $client.secret }}"
    redirectUris:
      {{- if $client.redirectUris }}
      {{- range $index2, $url := $client.redirectUris }}
      - {{ tpl $url $dot }}
      {{- end }}
      {{- else }}
      - "*"
      {{- end }}
      {{- if $client.webOrigins }}
    webOrigins:
      {{- range $index3, $web := $client.webOrigins }}
      - {{ $web }}
      {{- end }}
      {{- else }}
    webOrigins: []
      {{- end }}
    notBefore: 0
    bearerOnly: false
    consentRequired: false
    standardFlowEnabled: true
    implicitFlowEnabled: false
    directAccessGrantsEnabled: true
    serviceAccountsEnabled: false
    publicClient: false
    frontchannelLogout: true
    protocol: "{{ $client.protocol }}"
    attributes:
      id.token.as.detached.signature: "false"
      saml.assertion.signature: "false"
      saml.force.post.binding: "false"
      saml.multivalued.roles: "false"
      saml.encrypt: "false"
      saml.server.signature: "false"
      saml.server.signature.keyinfo.ext: "false"
      exclude.session.state.from.auth.response: "false"
      saml.artifact.binding: "false"
      saml_force_name_id_format: "false"
      saml.client.signature: "false"
      saml.authnstatement: "false"
      saml.onetimeuse.condition: "false"
      tls-client-certificate-bound-access-tokens: "false"
      oidc.ciba.grant.enabled: "false"
      backchannel.logout.session.required: "true"
      client_credentials.use_refresh_token: "false"
      acr.loa.map: "{}"
      require.pushed.authorization.requests: "false"
      oauth2.device.authorization.grant.enabled: "false"
      display.on.consent.screen: "false"
      backchannel.logout.revoke.offline.tokens: "false"
      token.response.type.bearer.lower-case: "false"
      use.refresh.tokens: "true"
      {{- if $client.additionalAttributes }}
      {{-   range $key,$value := $client.additionalAttributes }}
      {{ $key }}: {{ tpl $value $dot }}
      {{-   end }}
      {{- end }}
    authenticationFlowBindingOverrides: {}
    fullScopeAllowed: true
    nodeReRegistrationTimeout: -1
    protocolMappers:
      {{- if $client.protocolMappers }}
      {{- range $index2, $mapper := $client.protocolMappers }}
      - name: {{ $mapper.name }}
        protocol: "openid-connect"
        protocolMapper: {{ $mapper.protocolMapper }}
        consentRequired: false
        config:
          {{ toYaml $mapper.config | nindent 10 }}
      {{- end }}
      {{- end }}
    defaultClientScopes:
      - web-origins
      - acr
      - profile
      - email
      {{- if $client.additionalDefaultScopes }}
      {{-   range $index2, $scope := $client.additionalDefaultScopes }}
      - {{ $scope }}
      {{-   end }}
      {{- end }}
    optionalClientScopes:
      - address
      - phone
      - offline_access
      - groups
      - microprofile-jwt
  {{- end }}
{{- end }}

{{/*
Renders the defaulDefaultClientScopes section in a realm.
Usage:
{{ include "auth._defaultClientScopes" ( dict "dot" .Values) }}
*/}}
{{- define "auth._defaultClientScopes" -}}
{{- $dot := default . .dot -}}
{{- if $dot.defaultClientScopes }}
defaultDefaultClientScopes:
  {{- range $index, $scope := $dot.defaultClientScopes }}
  - {{ $scope }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Renders the clientScopes section in a realm.
Usage:
{{ include "auth._clientScopes" ( dict "dot" .Values) }}
*/}}
{{- define "auth._clientScopes" -}}
{{- $dot := default . .dot -}}
clientScopes:
{{- if $dot.additionalClientScopes }}
{{-   range $index, $scope := $dot.additionalClientScopes }}
- name: {{ $scope.name }}
  description: "{{ default "" $scope.description }}"
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'false'
    display.on.consent.screen: 'true'
    gui.order: ''
    consent.screen.text: "${rolesScopeConsentText}"
  protocolMappers:
    {{- if $scope.protocolMappers }}
    {{- range $index2, $mapper := $scope.protocolMappers }}
    - name: {{ $mapper.name }}
      protocol: "openid-connect"
      protocolMapper: {{ $mapper.protocolMapper }}
      consentRequired: false
      config:
        {{ toYaml $mapper.config | nindent 8 }}
    {{- end }}
    {{- end }}

{{-   end }}
{{- end }}
- name: roles
  description: OpenID Connect scope for add user roles to the access token
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'false'
    display.on.consent.screen: 'true'
    consent.screen.text: "${rolesScopeConsentText}"
  protocolMappers:
  - name: audience resolve
    protocol: openid-connect
    protocolMapper: oidc-audience-resolve-mapper
    consentRequired: false
    config: {}
  - name: realm roles
    protocol: openid-connect
    protocolMapper: oidc-usermodel-realm-role-mapper
    consentRequired: false
    config:
      user.attribute: foo
      access.token.claim: 'true'
      claim.name: realm_access.roles
      jsonType.label: String
      multivalued: 'true'
  - name: client roles
    protocol: openid-connect
    protocolMapper: oidc-usermodel-client-role-mapper
    consentRequired: false
    config:
      user.attribute: foo
      access.token.claim: 'true'
      claim.name: resource_access.${client_id}.roles
      jsonType.label: String
      multivalued: 'true'
- name: groups
  description: Membership to a group
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'true'
    gui.order: ''
    consent.screen.text: ''
  protocolMappers:
  - name: groups
    protocol: openid-connect
    protocolMapper: oidc-group-membership-mapper
    consentRequired: false
    config:
      full.path: 'false'
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: groups
      userinfo.token.claim: 'true'
- name: acr
  description: OpenID Connect scope for add acr (authentication context class reference)
    to the token
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'false'
    display.on.consent.screen: 'false'
  protocolMappers:
  - name: acr loa level
    protocol: openid-connect
    protocolMapper: oidc-acr-mapper
    consentRequired: false
    config:
      id.token.claim: 'true'
      access.token.claim: 'true'
- name: profile
  description: 'OpenID Connect built-in scope: profile'
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'true'
    consent.screen.text: "${profileScopeConsentText}"
  protocolMappers:
  - name: profile
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: profile
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: profile
      jsonType.label: String
  - name: given name
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: firstName
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: given_name
      jsonType.label: String
  - name: website
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: website
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: website
      jsonType.label: String
  - name: zoneinfo
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: zoneinfo
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: zoneinfo
      jsonType.label: String
  - name: locale
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: locale
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: locale
      jsonType.label: String
  - name: gender
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: gender
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: gender
      jsonType.label: String
  - name: family name
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: lastName
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: family_name
      jsonType.label: String
  - name: username
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: username
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: preferred_username
      jsonType.label: String
  - name: middle name
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: middleName
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: middle_name
      jsonType.label: String
  - name: birthdate
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: birthdate
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: birthdate
      jsonType.label: String
  - name: updated at
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: updatedAt
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: updated_at
      jsonType.label: long
  - name: full name
    protocol: openid-connect
    protocolMapper: oidc-full-name-mapper
    consentRequired: false
    config:
      id.token.claim: 'true'
      access.token.claim: 'true'
      userinfo.token.claim: 'true'
  - name: nickname
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: nickname
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: nickname
      jsonType.label: String
  - name: picture
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: picture
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: picture
      jsonType.label: String
- name: address
  description: 'OpenID Connect built-in scope: address'
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'true'
    consent.screen.text: "${addressScopeConsentText}"
  protocolMappers:
  - name: address
    protocol: openid-connect
    protocolMapper: oidc-address-mapper
    consentRequired: false
    config:
      user.attribute.formatted: formatted
      user.attribute.country: country
      user.attribute.postal_code: postal_code
      userinfo.token.claim: 'true'
      user.attribute.street: street
      id.token.claim: 'true'
      user.attribute.region: region
      access.token.claim: 'true'
      user.attribute.locality: locality
- name: web-origins
  description: OpenID Connect scope for add allowed web origins to the access token
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'false'
    display.on.consent.screen: 'false'
    consent.screen.text: ''
  protocolMappers:
  - name: allowed web origins
    protocol: openid-connect
    protocolMapper: oidc-allowed-origins-mapper
    consentRequired: false
    config: {}
- name: phone
  description: 'OpenID Connect built-in scope: phone'
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'true'
    consent.screen.text: "${phoneScopeConsentText}"
  protocolMappers:
  - name: phone number verified
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: phoneNumberVerified
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: phone_number_verified
      jsonType.label: boolean
  - name: phone number
    protocol: openid-connect
    protocolMapper: oidc-usermodel-attribute-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: phoneNumber
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: phone_number
      jsonType.label: String
- name: offline_access
  description: 'OpenID Connect built-in scope: offline_access'
  protocol: openid-connect
  attributes:
    consent.screen.text: "${offlineAccessScopeConsentText}"
    display.on.consent.screen: 'true'
- name: role_list
  description: SAML role list
  protocol: saml
  attributes:
    consent.screen.text: "${samlRoleListScopeConsentText}"
    display.on.consent.screen: 'true'
  protocolMappers:
  - name: role list
    protocol: saml
    protocolMapper: saml-role-list-mapper
    consentRequired: false
    config:
      single: 'false'
      attribute.nameformat: Basic
      attribute.name: Role
- name: microprofile-jwt
  description: Microprofile - JWT built-in scope
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'false'
  protocolMappers:
  - name: upn
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: username
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: upn
      jsonType.label: String
  - name: groups
    protocol: openid-connect
    protocolMapper: oidc-usermodel-realm-role-mapper
    consentRequired: false
    config:
      multivalued: 'true'
      user.attribute: foo
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: groups
      jsonType.label: String
- name: email
  description: 'OpenID Connect built-in scope: email'
  protocol: openid-connect
  attributes:
    include.in.token.scope: 'true'
    display.on.consent.screen: 'true'
    consent.screen.text: "${emailScopeConsentText}"
  protocolMappers:
  - name: email
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: email
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: email
      jsonType.label: String
  - name: email verified
    protocol: openid-connect
    protocolMapper: oidc-usermodel-property-mapper
    consentRequired: false
    config:
      userinfo.token.claim: 'true'
      user.attribute: emailVerified
      id.token.claim: 'true'
      access.token.claim: 'true'
      claim.name: email_verified
      jsonType.label: boolean
{{- end }}

{{/*
Renders the groups section in a realm.
Usage:
{{ include "auth._groups" ( dict "dot" .Values) }}
*/}}
{{- define "auth._groups" -}}
{{- $dot := default . .dot -}}
{{- if $dot.groups }}
groups:
{{-   range $index, $group := $dot.groups }}
  - name: "{{ $group.name }}"
    path: "{{ $group.path }}"
    attributes: {}
    {{- if $group.roles }}
    realmRoles:
      {{- range $index2, $groupRole := $group.roles }}
      - "{{ $groupRole }}"
      {{- end }}
    {{- else }}
    realmRoles: []
    {{- end }}
    clientRoles: {}
    subGroups: []
{{-   end }}
{{- else }}
groups: []
{{- end }}
{{- end }}

{{/*
Renders the users section in a realm.
Usage:
{{ include "auth._users" ( dict "dot" .Values) }}
*/}}
{{- define "auth._users" -}}
{{- $dot := default . .dot -}}
{{- if $dot.initialUsers }}
users:
  {{- range $index, $user := $dot.initialUsers }}
  - username: "{{ $user.username }}"
    enabled: true
    totp: false
    email: "{{ default "" $user.email }}"
    emailVerified: true
    {{- if $user.attributes }}
    attributes:
      {{ toYaml $user.attributes | nindent 6 }}
    {{- else }}
    attributes: {}
    {{- end }}
    {{- if $user.password }}
    credentials:
      - type: "password"
        temporary: false
        value: "{{ $user.password }}"
    {{- end }}
    {{- if $user.credentials }}
    credentials:
      {{ toYaml $user.credentials | nindent 6 }}
    {{- end }}
    disableableCredentialTypes: []
    requiredActions: []
    {{- if $user.realmRoles }}
    realmRoles:
      {{- range $index2, $realmRole := $user.realmRoles }}
      - "{{ $realmRole }}"
      {{- end }}
    {{- else }}
    realmRoles: [ "default-roles-{{ $dot.name }}" ]
    {{- end }}
    {{- if $user.clientRoles }}
    clientRoles:
      {{ toYaml $user.clientRoles | nindent 6 }}
    {{- end }}
    notBefore: 0
    groups: {{ $user.groups | toJson  }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Renders the identityProviders section in a realm.
Usage:
{{ include "auth._identity" ( dict "dot" .Values) }}
*/}}
{{- define "auth._identity" -}}
{{- $dot := default . .dot -}}
{{- if $dot.identityProviders }}
identityProviders:
{{-  range $index, $provider := $dot.identityProviders }}
  - alias: {{ $provider.name }}
    displayName: {{ $provider.displayName }}
    providerId: oidc
    enabled: true
    updateProfileFirstLoginMode: "on"
    trustEmail: true
    storeToken: true
    addReadTokenRoleOnCreate: true
    authenticateByDefault: false
    linkOnly: false
    firstBrokerLoginFlowAlias: "first broker login"
    config:
      {{ toYaml $provider.config | nindent 6 }}
{{-   end }}
{{- end }}
{{- end }}

{{/*
Renders the identityProviderMappers section in a realm.
Usage:
{{ include "auth._identityMapper" ( dict "dot" .Values) }}
*/}}
{{- define "auth._identityMapper" -}}
{{- $dot := default . .dot -}}
{{- if $dot.identityProviderMappers }}
identityProviderMappers:
{{-  range $index, $mapper := $dot.identityProviderMappers }}
  - name: {{ $mapper.name }}
    identityProviderAlias: {{ $mapper.identityProviderAlias }}
    identityProviderMapper: {{ $mapper.identityProviderMapper }}
    config:
      {{ toYaml $mapper.config | nindent 6 }}
{{-   end }}
{{- end }}
{{- end }}

{{/*
Renders the attributes section in a realm.
Usage:
{{ include "auth._attributes" ( dict "dot" . "realm" $realm ) }}
*/}}
{{- define "auth._attributes" -}}
{{- $dot := default . .dot -}}
{{- $realm := (required "'realm' param, set to the specific service, is required." .realm) -}}
attributes:
  frontentUrl: {{ tpl $realm.attributes.frontendUrl $dot }}
  acr.loa.map: "{\"ABC\":\"5\"}"
{{- end }}
