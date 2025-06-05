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
    accessTokenLifespan:            - (optional) Access Tolek Lifespan (default: 1900)
    registrationAllowed:            - (optional) Enable/disable the registration page (default: false)
    resetPasswordAllowed:           - (optional) Show a link on login page for user to click when they have forgotten their credentials (default: true)
    passwordPolicy:                 - (optional) Set Password policies, e.g.
                                      "length(8) and specialChars(1) and upperCase(1) and lowerCase(1) and digits(1) and notUsername(undefined)
                                       and notEmail(undefined) and notContainsUsername(undefined) and passwordHistory(3)"
    sslRequired:                    - (optional) Is HTTPS required? ('None'|'External'|'All requests' (default: "external")
    themes:                         - (optional) Keycloak Theme settings
      login: <login theme>          - (optional) Keycloak Theme for Login UI (e.g. "base")
      admin: <admin theme>          - (optional) Keycloak Theme for Admin UI (e.g. "base")
      account: <account theme>      - (optional) Keycloak Theme for Account UI (e.g. "base")
      email: <email theme>          - (optional) Keycloak Theme for Email UI (e.g. "base")
    attributes:                     - (optional)
      frontendUrl: "<Keycloak URL>" - (optional) External Url for Keycloak access (e.g. "https://keycloak.simpledemo.onap.org")
```

### CLIENT definitions

In this section each realm authentication client is defined e.g. portal-bff, oauth2-proxy, grafana

- possible "attributes" settings (maybe more):
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
        authorizationServicesEnabled: "<false|true>" - (optional) enable Authorization Services (RBAC) (default: false)
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
          - "https://portal.simpledemo.onap.org/*"
          - "http://localhost/*"
        webOrigins:
          - "https://argocd.simpledemo.onap.org"
        defaultClientScopes:                      - (optional) definition of default client scopes
          - "web-origins"                         -            if used, has to contain the full scope list
          - "profile"
          - "acr"
          - "email"
          - "roles"
          - "groups"
        optionalClientScopes:                      - (optional) definition of optional client scopes
          - ...                                    -            if used, has to contain the full scope list
```

#### Authorization settings within Client section (optional)

Information about the Keycloak Authorization Services can be found under: <https://www.keycloak.org/docs/latest/authorization_services/index.html>

To enable Authorization the setting shown above needs to be:
  - authorizationServicesEnabled: true

```yaml
        authorizationSettings:
          allowRemoteResourceManagement: "<false|true>"           - (optional) managed remotely by the resource server? (default: true)
          policyEnforcementMode: "<ENFORCING|PERMISSIVE|DISABLED>"- (optional) dictates how policies are enforced (default: ENFORCING)
          decisionStrategy: "<UNANIMOUS|AFFIRMATIVE>"             - (optional) dictates how permissions are evaluated (default: UNANIMOUS)
          resources:                                              - resources definitions
            - name: "<resource name>"                             - unique name for this resource
              displayName: "<display name>"                       - (optional) user-friendly name for the resource
              type: "<type>"                                      - Type can be used to group different resource instances with the same type
              ownerManagedAccess: <true|false>                    - (optional) access can be managed by the resource owner? (default: false)
              attributes: {}                                      - (optional) The attributes associated wth the resource
              uris:                                               - Set of URIs which are protected by resource
                - "/*"
                - ...
              scopes:                                             - The scopes associated with this resource
                - name: "<scope name1>"
                - ...
              icon_uri: "<uri>"                                   - (optional) A URI pointing to an icon.
            - ...
          policies:                                               - policy definitions
            - name: "<policy name>"                               - unique name for this policy
              description: "<description>"                        - (optional) A description for this policy
              type: "<role|client|...>"                           - Choose the policy type
              logic: "<POSITIVE|NEGATIVE>"                        - dictates how the policy decision should be made
              roles:                                              - Specifies the client roles allowed by this policy
                - id: "<role name>"                               - points to an existing role
                  required: <true|false>                          - decide, whether role is required
                ...
            - ...
          permissions:                                            - policy definitions
            - name: "<permission name>"                           - unique name for this permission
              description: "<description>"                        - (optional) A description for this permission
              type: "<scope|resource>"                            - Choose the permission type
              decisionStrategy: "<UNANIMOUS|AFFIRMATIVE|CONSENSUS>" - dictates how the policies associated with a given permission are evaluated
              resources:                                          - Specifies that this permission must be applied to a specific resource instance
                - "<resource name>"                               - points to an existing resource
                - ...
              scopes:                                             - Specifies that this permission must be applied to one or more scopes
                - "<scope name>"                                  - points to an existing scope
                - ...
              applyPolicies:                                      - Specifies all the policies that must be applied to the scopes defined by this permission
                - "<policy-name>"                                 - points to an existing policy
                - ...
            - ...
          scopes:                                                 - scope definitions
            - name: "<scope name>"                                - unique name for this scope
              iconUri: "<uri>"                                    - (optional) A URI pointing to an icon.
              displayName: "<display name>"                       - (optional) user-friendly name for the resource
            - ...
```

### CLIENT SCOPE definitions

Here additional scopes besides the default scopes can be defined and set as defaul client scope
default scopes: roles, groups, acr, profile, address, web-origin, phone, email, offline_access, role_list, microprofile-jwt

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
default roles: user, admin, offline_access, uma_authorization, default-roles-<realm>

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
        requiredActions:            - (optional) action, the user has to execute
          - <action>                - e.g. "UPDATE_PASSWORD", "UPDATE_PROFILE",...
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
          userInfoUrl: "https://<gitlab-url>/oauth/userinfo"
          validateSignature: "true"
          clientId: "<client ID>"
          tokenUrl: "https://<gitlab-url>/oauth/token"
          jwksUrl: "https://<gitlab-url>/oauth/discovery/keys"
          issuer: "https://<gitlab-url>"
          useJwksUrl: "true"
          authorizationUrl: "https://<gitlab-url>/oauth/authorize"
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
      password: "<password>"
      starttls: "true"
      auth: "true"
      port: "587"
      host: "<mailserver>"
      from: "<mail-address>"
      fromDisplayName: "onapsupport"
      ssl: "false"
      user: "onapsupport"
```

## Requirements

authentication needs the following ONAP projects to work:

- common
- serviceAccount
