TBD: Description about settings...


```
realmSettings:
  - name: <Realm ID>                - unique ID for a realm (e.g. "ONAP")
    displayName: <Display Name>     - (optional) Keycloak Display Name (e.g. "ONAP Realm")
    themes:                         - (optional) Keycloak Theme settings
      login: <login theme>          - (optional) Keycloak Theme for Login UI (e.g. "base")
      admin: <admin theme>          - (optional) Keycloak Theme for Admin UI (e.g. "base")
      account: <account theme>      - (optional) Keycloak Theme for Account UI (e.g. "base")
      email: <email theme>          - (optional) Keycloak Theme for Email UI (e.g. "base")
    groups:                         - (optional) Group definitions
      - name: <group name>          - Group name
        path: /path>                - Group URL path
        realmRoles: [ <role>,... ]  - (optional) List of Realm roles
    initialUsers:                   - (optional) List of initial users
      - username: <user name>       - Name of the User
        password: <password>        - Initial Password
        email: <email>              - Email Address
        firstName: <first name>     - (optional) First Name
        lastName: <last name>       - (optional) Last Name
        groups:                     - (optional) group membership
          - <group name>
```

```
    clients:
      oauth2_proxy:
        clientId: "oauth2-proxy-onap"
        name: "Oauth2 Proxy"
        secret: 5YSOkJz99WHv8enDZPknzJuGqVSerELp
        protocol: openid-connect
      portal_app:
        clientId: "portal-app"
        redirectUris:
          - "https://portal-$PARAM_BASE_URL/*"
          - "http://localhost/*"
        protocol: openid-connect
```

```
    accessControl:
      assignableRoles:
        - name: onap-operator-read
          description: "Allows to perform GET operations for all ONAP components"
          associatedAccessRoles: [ "dmaap-bc-api-read", "dmaap-dr-node-api-read", "dmaap-dr-prov-api-read", "dmaap-mr-api-read", "msb-consul-api-read", "msb-discovery-api-read", "msb-eag-ui-read", "msb-iag-ui-read", "nbi-api-read", "aai-api-read", "aai-babel-api-read", "aai-sparkybe-api-read", "cds-blueprintsprocessor-api-read", "cds-ui-read", "cps-core-api-read", "cps-ncmp-dmi-plugin-api-read", "cps-temporal-api-read", "reaper-dc1-read", "sdc-be-api-read", "sdc-fe-ui-read", "sdc-wfd-be-api-read", "sdc-wfd-fe-ui-read", "so-admin-cockpit-ui-read", "so-api-read", "usecase-ui-read", "uui-server-read" ]

      accessRoles:
        "oauth2_proxy":
        - name: dmaap-bc-api-read
          methodsAllowed: ["GET"]
          servicePrefix: dmaap-bc-api
```