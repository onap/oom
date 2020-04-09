command = '/usr/bin/gunicorn'
pythonpath = '/opt/netbox/netbox'
bind = '0.0.0.0:{{ .Values.service.internalPort }}'
workers = 3
errorlog = '-'
accesslog = '-'
capture_output = False
loglevel = 'debug'
