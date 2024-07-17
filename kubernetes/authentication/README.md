# Helm Chart for Authentication Application

This component delivers:

- Keycloak Realm creation and import
- (Optionally) creation of AuthenticationPolicies for Ingress to enable
  OAuth Authentication and RoleBased access to Ingress APIs and UIs

## REALM Configuration settings

- In the configuration section "realmSettings" multiple REALMs can be configured
- Each REALM configuration has the following sections:
  - [General REALM settings](#general-realm-settings)
  - [CLIENT definitions](#client-definitions)
  - (optional) [CLIENT SCOPE definitions](#client-scope-definitions)
  - (optional) [Access control definitions](#access-control-definitions)
  - (optional) [GROUP definitions](#group-definitions)
  - (optional) [USER definitions](#user-definitions)
  - (optional) [IDENTITY PROVIDER definitions](#identity-provider-and-mapper-definitions)
  - (optional) [SMTP server definitions](#smtp-server-definitions)

### General REALM settings

This sections sets the realm general attributes shown in Keycloak

```yaml
realmSettings:
  - name: <Realm ID>                - unique ID for a realm (e.g. "ONAP")
    displayName: <Display Name>     - (optional) Keycloak Display Name (e.g. "ONAP Realm")
    themes:                         - (optional) Keycloak Theme settings
      login: <login theme>          - (optional) Keycloak Theme for Login UI (e.g. "base")
      admin: <admin theme>          - (optional) Keycloak Theme for Admin UI (e.g. "base")
      account: <account theme>      - (optional) Keycloak Theme for Account UI (e.g. "base")
      email: <email theme>          - (optional) Keycloak Theme for Email UI (e.g. "base")
    attributes:
      frontendUrl: "<Keycloak URL>" - External Url for Keycloak access (e.g. "https://keycloak-$PARAM_BASE_URL/")
```

### CLIENT definitions

In this section each realm authentication client is defined e.g. portal-bff, oauth2-proxy, grafana

possible "attribute" settings (maybe more):
  - id.token.as.detached.signature: "false"
  - exclude.session.state.from.auth.response: "false"
  - tls.client.certificate.bound.access.tokens: "false"
  - saml.allow.ecp.flow: "false"
  - saml.assertion.signature: "false"
  - saml.force.post.binding: "false"
  - saml.multivalued.roles: "false"
  - saml.encrypt: "false"
  - saml.server.signature: "false"
  - saml.server.signature.keyinfo.ext: "false"
  - saml.artifact.binding: "false"
  - saml_force_name_id_format: "false"
  - saml.client.signature: "false"
  - saml.authnstatement: "false"
  - saml.onetimeuse.condition: "false"
  - oidc.ciba.grant.enabled: "false"
  - frontchannel.logout.session.required: "true"
  - backchannel.logout.session.required: "true"
  - backchannel.logout.revoke.offline.tokens: "false"
  - client_credentials.use_refresh_token: "false"
  - acr.loa.map: "{}"
  - require.pushed.authorization.requests: "false"
  - oauth2.device.authorization.grant.enabled: "false"
  - display.on.consent.screen: "false"
  - token.response.type.bearer.lower-case: "false"
  - use.refresh.tokens: "true"
  - post.logout.redirect.uris: '<url>'

```yaml
    clients:
      oauth2_proxy:
        clientId: "<client ID>"                   - client ID
        name: "<client name>"                     - (optional) client name
        secret: <client secret>                   - (optional) client secret
        clientAuthenticatorType: <type>           - (optional) auth type (default: client-secret)
        protocol: <protocol>                      - (optional) auth protocol (default: openid-connect)
        description: "<description>"              - (optional) client description
        baseUrl: "<base path>"                    - (optional) url subpath (e.g. /application)
        rootUrl: "<root URL>"                     - (optional) root url
        adminUrl: "<admin URL>"                   - (optional) admin url
        bearerOnly: "<false|true>"                - (optional) bearerOnly (default: false)
        consentRequired: "<false|true>"           - (optional) consentRequired (default: false)
        standardFlowEnabled: "<false|true>"       - (optional) standardFlowEnabled (default: true)
        implicitFlowEnabled: "<false|true>"       - (optional) implicitFlowEnabled (default: false)
        directAccessGrantsEnabled: "<false|true>" - (optional) directAccessGrantsEnabled (default: true)
        serviceAccountsEnabled: "<false|true>"    - (optional) serviceAccountsEnabled (default: false)
        frontchannelLogout: "<false|true>"        - (optional) frontend channel logout (default: true)
        surrogateAuthRequired: "<false|true>"     - (optional) surrogate Auth Required (default: false)
        publicClient: "<false|true>"              - (optional) public Client (default: false)
        attributes:                               - (optional) attributes settings (see code)
          post.logout.redirect.uris: '<url>'      - example
        protocolMappers:                          - (optional) protocol mappers
          - name: "Audience for Oauth2Proxy"      - examples
            protocolMapper: "oidc-audience-mapper"
            config:
              included.client.audience: "oauth2-proxy-onap"
              id.token.claim: "false"
              access.token.claim: "true"
              included.custom.audience: "oauth2-proxy-onap"
          - name: "SDC-User"
            protocolMapper: "oidc-usermodel-attribute-mapper"
            config:
              multivalued: "false"
              userinfo.token.claim: "true"
              user.attribute: "sdc_user"
              id.token.claim: "true"
              access.token.claim: "true"
              claim.name: "sdc_user"
              jsonType.label: "String"
        additionalDefaultScopes:
          - "onap_roles"
        redirectUris:
          - "https://portal-$PARAM_BASE_URL/*"
          - "http://localhost/*"
        webOrigins:
          - "https://argocd-$PARAM_BASE_URL"
        defaultClientScopes:
          - "web-origins"
          - "profile"
          - "acr"
          - "email"
          - "roles"
          - "groups"
```

### CLIENT SCOPE definitions

Here additional scopes besides the default scopes can be defined and set as default client scope

default scopes:

  - roles
  - groups
  - acr
  - profile
  - address
  - web-origin
  - phone
  - email
  - offline_access
  - role_list
  - microprofile-jwt

```yaml
    defaultClientScopes:
      - "onap_roles"
    additionalClientScopes:
      - name: onap_roles
        description: OpenID Connect scope for add user onap roles to the access token
        protocolMappers:
        - name: aud
          protocol: openid-connect
          protocolMapper: oidc-audience-mapper
          consentRequired: false
          config:
            included.client.audience: oauth2-proxy
            id.token.claim: 'false'
            access.token.claim: 'true'
        - name: client roles
          protocol: openid-connect
          protocolMapper: oidc-usermodel-client-role-mapper
          consentRequired: false
          config:
            multivalued: 'true'
            userinfo.token.claim: 'false'
            id.token.claim: 'true'
            access.token.claim: 'true'
            claim.name: onap_roles
            jsonType.label: String
            usermodel.clientRoleMapping.clientId: oauth2-proxy
```

### Access control definitions

In this section additional roles (assignableRoles) besides the default roles can be set.

default roles:
  - user
  - admin
  - offline_access
  - uma_authorization
  - default-roles-<realm>

(optional) accessRoles can be defined.
These access roles are used in the Ingress "Auhorization Policy" to restrict the access to certain services
The access role is assigned to a realm client (e.g. oauth2_proxy)

```yaml
    accessControl:
      assignableRoles:
        - name: onap-operator-read
          description: "Allows to perform GET operations for all ONAP components"
          associatedAccessRoles: [ "dmaap-bc-api-read", ... ]
      accessRoles:
        "oauth2_proxy":
        - name: dmaap-bc-api-read
          methodsAllowed: ["GET"]
          servicePrefix: dmaap-bc-api
```

### GROUP definitions

```yaml
    groups:                         - (optional) Group definitions
      - name: <group name>          - Group name
        path: /path>                - Group URL path
        roles: [ <role>,... ]       - (optional) List of Realm roles
```

### USER definitions

```yaml
    initialUsers:                   - (optional) List of initial users
      - username: <user name>       - Name of the User
        firstName: <first name>     - (optional) First Name
        lastName: <last name>       - (optional) Last Name
        email: <email>              - (optional) Email Address
        emailVerified : <true|false>- (optional)Email verified
        credentials:                - (optional) credentials
          - type: password          - (optional) initial password (<pwd>: encrypted password, <salt>: used salt)
            secretData: "{\"value\":\"<pwd>\",\"salt\":\"<salt>\"}"
            credentialData: "{\"hashIterations\":27500,\"algorithm\":\"pbkdf2-sha256\"}"
        attributes:                 - (optional) additional attributes
          sdc_user:                 - example attribute
            - "cs0008"
        realmRoles:                 - (optional) assigned realm roles
          - <role name>
        groups:                     - (optional) group membership
          - <group name>
```

### Identity Provider and Mapper definitions

```yaml
    identityProviders:
      - name: "gitlab"
        displayName: "gitlab"
        config:
          userInfoUrl: "https://gitlab.devops.telekom.de/oauth/userinfo"
          validateSignature: "true"
          clientId: "ee4e0db734157e9cdad16733656ba285f2f813354aa7c590a8693e48ed156860"
          tokenUrl: "https://gitlab.devops.telekom.de/oauth/token"
          jwksUrl: "https://gitlab.devops.telekom.de/oauth/discovery/keys"
          issuer: "https://gitlab.devops.telekom.de"
          useJwksUrl: "true"
          authorizationUrl: "https://gitlab.devops.telekom.de/oauth/authorize"
          clientAuthMethod: "client_secret_post"
          syncMode: "IMPORT"
          clientSecret: "gloas-35267790bf6fb7c4b507aea11db46d80174cb8ef4192e77424803b595eef735e"
          defaultScope: "openid read_user email"
    identityProviderMappers:
      - name: "argo-admins"
        identityProviderAlias: "gitlab"
        identityProviderMapper: "oidc-advanced-group-idp-mapper"
        config:
          claims: "[{\"key\":\"groups_direct\",\"value\":\"dt-rc\"}]"
          syncMode: "FORCE"
          group: "/ArgoCDAdmins"
      - name: "ArgoCDRestricted"
        identityProviderAlias: "gitlab"
        identityProviderMapper: "oidc-advanced-group-idp-mapper"
        config:
          claims: "[{\"key\":\"groups_direct\",\"value\":\"\"}]"
          syncMode: "FORCE"
          group: "/ArgoCDRestricted"
      - name: "lastName "
        identityProviderAlias: "gitlab"
        identityProviderMapper: "oidc-user-attribute-idp-mapper"
        config:
          claim: "nickname"
          syncMode: "FORCE"
          user.attribute: "lastName"
```

### SMTP Server definitions

```yaml
    smtpServer:
      password: "EYcQE44+AEYcQE44A!"
      starttls: "true"
      auth: "true"
      port: "587"
      host: "mailauth.telekom.de"
      from: "dl_t-nap_support@telekom.de"
      fromDisplayName: "tnapsupport"
      ssl: "false"
      user: "tnapsupport"
```

## Ingress Authentication settings

Activating the Ingress Authentication (enabled: true) will create AuthorizationPolicy resources for each defined "accessControl.accessRoles" in a REALM definition.

```
ingressAuthentication:
  enabled: false
  exceptions:
    - '{{ include "ingress.config.host" (dict "dot" . "baseaddr" "keycloak-ui") }}'
    - '{{ include "ingress.config.host" (dict "dot" . "baseaddr" "portal-ui") }}'
    - '{{ include "ingress.config.host" (dict "dot" . "baseaddr" "minio-console") }}'
    - '{{ include "ingress.config.host" (dict "dot" . "baseaddr" "uui-server") }}'
```