 # -------------------------------------------------------------------------
 #   Copyright (c) 2019 Amdocs
 #
 #   Licensed under the Apache License, Version 2.0 (the "License");
 #   you may not use this file except in compliance with the License.
 #   You may obtain a copy of the License at
 #
 #       http://www.apache.org/licenses/LICENSE-2.0
 #
 #   Unless required by applicable law or agreed to in writing, software
 #   distributed under the License is distributed on an "AS IS" BASIS,
 #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #   See the License for the specific language governing permissions and
 #   limitations under the License.
 #
 # -------------------------------------------------------------------------
 #
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








