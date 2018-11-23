#!/usr/bin/env python

#
#     Copyright (c) 2018 Orange
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#

"""
Provides utilities to display oom (sub)modules resources stats
"""

import os
import sys
import getopt
from fnmatch import fnmatch as match
import yaml

def info(thing):
    if thing:
        sys.stderr.write("{}\n".format(thing))

try:
    from tabulate import tabulate
except ImportError as e:
    info("Warning: cannot import tabulate module (): {}".format(str(e)))
    def tabulate(lines, headers, tablefmt=None):
        ''' basic tabulate function '''
        fmt = ""
        nbco = len(headers)
        lenco = map(len, headers)
        for line in lines:
            for i in range(nbco):
                lenco[i] = max(lenco[i], len(str(line[i])))

        fmt = map(lambda n: "{{:<{}}}".format(n), map(lambda i: i+2, lenco))
        fmt = "  ".join(fmt)
        sep = map(lambda x: '-'*(x+2), lenco)

        output = [fmt.format(*headers), fmt.format(*sep)]
        for line in lines:
            output.append(fmt.format(*line))
        return "\n".join(output)


def values(root='.'):
    ''' Get the list of values.yaml files '''
    a = []
    for dirname, dirnames, filenames in os.walk(root):
        for filename in filenames:
            if filename == 'values.yaml':
                a.append((dirname, filename))

        if '.git' in dirnames:
            # don't go into any .git directories.
            dirnames.remove('.git')
    return a


def keys(dic, prefix=None):
    ''' recursively traverse the specified dict to collect existing keys '''
    result = []
    if dic:
        for k, v in dic.items():
            if prefix:
                k = '.'.join((prefix, k))
            if isinstance(v, dict):
                result += keys(v, k)
            else:
                result.append(k)
    return result


class Project:
    '''
    class to access to oom (sub)module (aka project) resources
    '''

    def __init__(self, dirname, filename):
        self.dirname = os.path.normpath(dirname)
        self.name = self.explicit()
        self.filename = os.path.join(dirname, filename)
        self.resources = None
        self.load()

    def load(self):
        ''' load resources from yaml description '''
        with open(self.filename, 'r') as istream:
            try:
                v = yaml.load(istream)
                if v:
                    self.resources = v.get('resources', None)
            except Exception as e:
                print(e)
                raise

    def explicit(self):
        ''' return an explicit name for the project '''
        path = []
        head, name = os.path.split(self.dirname)
        if not name:
            return head
        while head:
            head, tail = os.path.split(head)
            if tail:
                path.append(tail)
            else:
                path.append(head)
                head = None
        path.reverse()
        index = path.index('charts') if 'charts' in path else None
        if index:
            name = os.path.join(path[index-1], name)
        return name

    def __contains__(self, key):
        params = self.resources
        if key:
            for k in key.split('.'):
                if params and k in params:
                    params = params[k]
                else:
                    return False
        return True

    def __getitem__(self, key):
        params = self.resources
        for k in key.split('.'):
            if k in params:
                params = params[k]
        if params != self.resources:
            return params

    def get(self, key, default="-"):
        """ mimic dict method """
        if key in self:
            return self[key]
        return default

    def keys(self):
        """ mimic dict method """
        return keys(self.resources)


#
#
#

def usage(status=None):
    """ usage doc """
    arg0 = os.path.basename(os.path.abspath(sys.argv[0]))
    print("""Usage: {} [options] <root-directory>""".format(arg0))
    print((
        "\n"
        "Options:\n"
        "-h, --help           Show this help message and exit\n"
        "-t, --table <format> Use the specified format to display the result table.\n"
        "                     Valid formats are those from the python `tabulate'\n"
        "                     module. When not available, a basic builtin tabular\n"
        "                     function is used and this field has no effect\n"
        "-f, --fields         Comma separated list of resources fields to display.\n"
        "                     You may use wildcard patterns, eg small.*. Implicit\n"
        "                     value is *, ie all available fields will be used\n"
        "Examples:\n"
        "    # {0} /opt/oom/kubernetes\n"
        "    # {0} -f small.\\* /opt/oom/kubernetes\n"
        "    # {0} -f '*requests.*' -t fancy_grid /opt/oom/kubernetes\n"
        "    # {0} -f small.requests.cpu,small.requests.memory /opt/oom/kubernetes\n"
    ).format(arg0))
    if status is not None:
        sys.exit(status)


def getopts():
    """ read options from cmdline """
    opts, args = getopt.getopt(sys.argv[1:],
                               "hf:t:",
                               ["help", "fields=", "table="])
    if len(args) != 1:
        usage(1)

    root = args[0]
    table = None
    fields = ['*']
    patterns = []

    for opt, arg in opts:
        if opt in ("-h", '--help'):
            usage(0)
        elif opt in ("-f", "--fields"):
            fields = arg.split(',')
        elif opt in ("-t", "--table"):
            table = arg

    return root, table, fields, patterns


def main():
    """ main """
    try:
        root, table, fields, patterns = getopts()
    except getopt.GetoptError as e:
        print("Error: {}".format(e))
        usage(1)

    if not os.path.isdir(root):
        info("Cannot open {}: Not a directory".format(root))
        return

    # find projects
    projects = []
    for dirname, filename in values(root):
        projects.append(Project(dirname, filename))
    if not projects:
        info("No projects found in {} directory".format(root))
        return

    # check if we want to use pattern matching (wildcard only)
    if fields and reduce(lambda x, y: x or y,
                         map(lambda string: '*' in string, fields)):
        patterns = fields
        fields = []

    # if fields are not specified or patterns are used, discover available fields
    #  and use them (sort for readability)
    if patterns or not fields:
        avail = sorted(set(reduce(lambda x, y: x+y,
                                  map(lambda p: p.keys(), projects))))
        if patterns:
            for pattern in patterns:
                fields += filter(lambda string: match(string, pattern), avail)
        else:
            fields = avail

    # collect values for each project
    results = map(lambda project: [project.name] + map(project.get,
                                                       fields),
                  projects)

    # and then print
    if results:
        headers = ['project'] + fields
        print(tabulate(sorted(results), headers, tablefmt=table))


main()
