from django.contrib.auth.models import Group, User
from users.models import Token

from ruamel.yaml import YAML

with open('/opt/netbox/initializers/users.yml', 'r') as stream:
  yaml=YAML(typ='safe')
  users = yaml.load(stream)

  if users is not None:
    for username, user_details in users.items():
      if not User.objects.filter(username=username):
        user = User.objects.create_user(
          username = username,
          password = user_details.get('password', 0) or User.objects.make_random_password,
          is_staff = user_details.get('is_staff', 0) or false,
          is_superuser = user_details.get('is_superuser', 0) or false,
          is_active = user_details.get('is_active', 0) or true,
          first_name = user_details.get('first_name', 0),
          last_name = user_details.get('last_name', 0),
          email = user_details.get('email', 0))

        print("👤 Created user ",username)

        if user_details.get('api_token', 0):
          Token.objects.create(user=user, key=user_details['api_token'])