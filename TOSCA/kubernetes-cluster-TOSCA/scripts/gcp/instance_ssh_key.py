
import re
from cloudify import ctx, manager
from cloudify.state import ctx_parameters as inputs
from cloudify.exceptions import NonRecoverableError

USER = 'user'
SSH_KEYS = 'ssh_keys'


def get_key_user_string(user, public_key):
    cleaned_user = re.sub(r'\s+', ' ', user).strip()
    cleaned_public_key = re.sub(r'\s+', ' ', public_key).strip()

    if cleaned_public_key.count(' ') >= 1:
        keytype, key_blob = cleaned_public_key.split(' ')[:2]
    else:
        raise NonRecoverableError('Incorrect format of public key')
    protocol = '{0}:{1}'.format(cleaned_user, keytype)

    return '{0} {1} {2}'.format(protocol, key_blob, cleaned_user)


if __name__ == '__main__':

    client = manager.get_rest_client()
    _context = client.manager.get_context()
    _cloudify_agent = \
        _context.get('context',
                     {}).get('cloudify',
                             {}).get('cloudify_agent', {})
    if 'agent_key_path' in _cloudify_agent.keys() \
            and (_cloudify_agent['agent_key_path'] == None
                 or _cloudify_agent['agent_key_path'] == ''):
        del _context['context']['cloudify']['cloudify_agent']['agent_key_path']
        client.manager.update_context(
            name='provider',
            context=_context['context'])
    instance_keys = ctx.instance.runtime_properties.get(SSH_KEYS, [])
    _user = inputs[USER]
    _keys = inputs[SSH_KEYS]
    for _key in _keys:
        key_user_string = get_key_user_string(_user, _key)
        instance_keys.append(key_user_string)
    ctx.instance.runtime_properties[SSH_KEYS] = instance_keys
