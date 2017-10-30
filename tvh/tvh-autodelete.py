#!/usr/bin/python

import os, sys, time, json

# 28 days -> 60*60*24*28 = 2419200 seconds
KEEP_TS = time.time() - 2419299

PATH = '/srv/datadisk/recordings'
SKIP = []
DEBUG = False

def usage():
    print sys.argv[0]  + ' <action>'
    print 'ACTIONS:'
    print ' --cron\t\trun with cron'
    print ' --test\t\ttest run and print what would happen'

def debug(msg):
    if DEBUG == True:
        print "DEBUG: " + msg

def delete_empty_dir(filepath):
    files = os.listdir(filepath)
    if len(files) == 0:
        debug("delete empty dir " + str(filepath))
        if DEBUG == False:
            os.rmdir(filepath)

def delete_old_file(filepath):
    file_ts = os.path.getmtime(filepath)
    if file_ts < KEEP_TS:
        debug("delete old file " + str(filepath))
        if DEBUG == False:
            os.remove(filepath)

def skip_file(file):
    for string in SKIP:
        debug("search '" + str(string) + "' in '" + str(file) +"'")
        if string in file:
            return True
    return False

def recursive_delete(location):
    debug("processing directory '" + str(location) + "'")
    files = os.listdir(location)
    for file in files:
        filepath = location + '/' + file
        if os.path.isdir(filepath):
            recursive_delete(filepath)
            delete_empty_dir(filepath)
        else:
            debug("processing file '" + str(file) + "'")
            if skip_file(file):
                debug("file skipped")
                continue
            delete_old_file(filepath)

if len(sys.argv) != 2:
    usage()
    sys.exit(1)

if not sys.argv[1] in ['--test', '--cron']:
    usage()
    sys.exit(2)

if sys.argv[1] == '--test':
    DEBUG = True

# load settings
conffile = '/etc/tvh.json'
#if not os.path.exists(conffile):
#    settings = {}
#    settings['last-mod-time'] = 28
#    settings['root-dir'] = '/file/path'
#    settings['skip-list'] = [ 'example 1', 'example 2' ]
#    with open(conffile, 'wb') as fp:
#        json.dump(settings, fp, indent=4)
with open(conffile, 'rb') as fp:
    settings = json.load(fp)
for key in [ 'last-mod-time', 'root-dir', 'skip-list']:
    if key not in settings.keys():
        print "Error: key '" + key + "' not found in settings file"
        sys.exit(1)

KEEP_TS = time.time() - settings['last-mod-time'] * 60 * 60 * 24
PATH = settings['root-dir']
SKIP = settings['skip-list']

if not os.path.exists(PATH):
    print "Error: path '" + PATH + "' does not exists"
    sys.exit(1)

recursive_delete(PATH)
