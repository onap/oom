user Cookbook
=============
Configures users and mechids

Requirements
------------

Attributes
----------
#### user::mech_users
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['aai-app-config']['mech-ids']</tt></td>
    <td>Hash</td>
    <td>Mech ID, is the mech ID enabled?, shoud the cookbook update the key?</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### user::default
Just include `user` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[user]"
  ]
}
```

License and Authors
-------------------
Authors: AT&T A&AI
