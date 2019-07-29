import jsonschema
import yaml
import json
import sys
import os


def open_json_schema(filePath):
    reader = open(filePath)
    try:
        json_schema = json.loads(reader.read())
    except ValueError as e:
        raise RuntimeError("Invalid JSON schema")
    else:
        return json_schema


def open_values_yaml(filePath):
    reader = open(filePath)
    try:
        values_yaml = yaml.safe_load(reader.read())
    except:
        raise RuntimeError("Error in loading Values.yaml")
    else:
        return values_yaml

curdir_path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
schemaPath =curdir_path + "/oom/kubernetes/schema.json"
valuesPath = sys.argv[1]
chart=sys.argv[2]
flag=sys.argv[3]
try:
    jsonschema.validate(open_values_yaml(valuesPath), open_json_schema(schemaPath))
except jsonschema.exceptions.ValidationError as error:
    if flag == '-d':
	print str(error).replace("u'", "'")
    else:
	print "Chart schema of \'" + chart + "\' is invalid. Error: " + str(error.message).replace("u'","'")
else:
    print "Chart schema of \'" + chart + "\' is valid" 








