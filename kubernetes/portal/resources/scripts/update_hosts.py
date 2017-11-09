#!/usr/bin/python
import getopt
import json
import socket
import subprocess
import sys
import time
from pathlib import Path

DEBUG = True
REGEX_HOSTS = '^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+[[:blank:]]\+'
ETC_HOSTS = '/etc/hosts'


def apply_mappings(mapping_file):
    with open(mapping_file) as data_file:
        data = json.load(data_file)
    for item in data['hosts']:
        source = item['source']
        destination = item['destination']
        try:
            ip = socket.gethostbyname(source)
            hosts = open(ETC_HOSTS, 'r')
            try:
                lines = hosts.readlines()
            finally:
                hosts.close()
            found = False
            for line in lines:
                if line.startswith('#'):
                    continue
                pair = line.split()
                if line.__len__() < 2:
                    continue
                old_ip = pair[0]
                old_destination = pair[1]
                if destination == old_destination:
                    found = True
                    if ip != old_ip:
                        if DEBUG:
                            print("Replacing [%s] with [%s] for [%s]" % (old_ip, ip, destination))
                        tmp_hosts = "hosts.tmp"
                        subprocess.call(["cp", ETC_HOSTS, tmp_hosts])
                        s = "s/" + REGEX_HOSTS + destination + "/" + ip + " " + destination + "/g"
                        subprocess.call(["sed", "-i", "-e", s, tmp_hosts])
                        # subprocess.call(["sed", "-i", "-e", s, '/c' + tmp_hosts])
                        subprocess.call(["cp", tmp_hosts, ETC_HOSTS])
            if not found:
                if DEBUG:
                    print("Adding [%s] for [%s]" % (ip, destination))
                f = open(ETC_HOSTS, 'a')
                try:
                    f.write('\n' + ip + ' ' + destination)
                finally:
                    f.close()
        except Exception as e:
            if DEBUG:
                print("Cannot update %s record for [%s -> %s]. %s" % (ETC_HOSTS, destination, source, str(e)))


DESCRIPTION = "Utility script updating /etc/hosts with mappings specified in input file"
USAGE = "Usage: update_hosts.py -f <file> [-t <sleep_time>]\n"\
    "where\n"\
    "<file> - Configuration JSON file with host mapings\n"\
    "<sleep_time> - Sleep time\n"
DEF_CONF_FILE = 'hosts.json'
DEF_SLEEP_TIME = 10


def main(argv):
    try:
        mapping_file = DEF_CONF_FILE
        sleep_time = DEF_SLEEP_TIME
        opts, args = getopt.getopt(argv, "hf:t:", ["file=", "time="])
        for opt, arg in opts:
            if opt == '-h':
                print(DESCRIPTION + "\n\n" + USAGE)
                sys.exit()
            elif opt in ("-f", "--file"):
                mapping_file = arg
            elif opt in ("-t", "--time"):
                sleep_time = float(arg)
    except getopt.GetoptError:
        print(USAGE)
        sys.exit(2)
    if not Path(mapping_file).exists():
        print("Input file [%s] does not exist\n", mapping_file)
        print(USAGE)
        sys.exit(2)
    while True:
        try:
            # if DEBUG:
            #     print("Updating %s records" % ETC_HOSTS)
            apply_mappings(mapping_file)
        except Exception as e:
            if DEBUG:
                print("Cannot update %s records %s" % (ETC_HOSTS, str(e)))
        finally:
            time.sleep(sleep_time)


if __name__ == "__main__":
    main(sys.argv[1:])
