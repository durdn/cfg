#!/usr/bin/env python
import os
import glob
import sys
from os.path import join,normpath,abspath,islink, split
from pprint import pprint
import hashlib
from pprint import pformat
from itertools import combinations
import logging

import logging as log
log.basicConfig(level=logging.INFO)

maxres = 20

def call(command,fake = False):
    """
        call(command) --> (result, output)
        Runs the command in the local shell returning a tuple 
        containing :
            - the return result (None for 0, otherwise an int), and
            - the full, stripped standard output.

        You wouldn't normally use this, instead consider call(), test() and system()
    """
    if fake:
        return

    process = os.popen(command)
    output = []
    line = process.readline()

    while not line == "":
        sys.stdout.flush()
        output.append(line)
        line = process.readline()
    result = process.close()

    return (result, "".join(output).strip())

def combbyx(a):
    if len(a) > 0:
        return [(a,'')] + [(a[:n],a[n:]) for n in reversed(range(len(a)))]
        #return [(a[:n],a[n:]) for n in reversed(range(len(a))) if n >= 3]
    else:
        return []

def revstr(s):
    ls = list(s)
    ls.reverse()
    return ''.join(ls)

def chunk(combination,tosearch,found):
    log.debug('checking combination %s with remainder ' % (revstr(combination[0]), revstr(combination[1])))
    for i,r in enumerate(tosearch):
        rres = revstr(r)
        if combination[0] in rres:
            found.add(r)
    if found:
        log.debug('found %s' % len(found))
        log.debug('found %s' % pformat(found))
    return found, combination[1]

def onepass(target, tosearch):
    found = set()
    remainder = None
    log.debug('target %s' % revstr(target))
    if len(target) > 3:
        combs = combbyx(target)
    else:
        return tosearch, ''

    for i, combination in enumerate(combs):
        if found:
            return found, remainder

        if combination[0] != '':
            for j,r in enumerate(tosearch):
                rres = revstr(r)
                if combination[0] in rres:
                    found.add(r)
            if found:
                log.debug('combination %s %s' % (i, revstr(combination[0])))
                log.debug('remainder [%s]' % revstr(combination[1]))
                remainder = combination[1]


if __name__ == '__main__':
    target = sys.argv[1]
    files = call('git ls-files')[1].split('\n')
    fwt = []
    for f in files:
        tail = split(f)[1] if len(split(f)) > 1 else None
        fwt.append((f,set(f),set(tail)))

    tosearch = []
    case = {}
    for f in fwt:
        if f[1] and set(target).issubset(f[1]):
            tosearch.append(f[0].lower())
            case[f[0].lower()] = f[0]

    tosearch.sort()
    #print 'results:',len(res)
    #pprint(res[:10])

    tlen = len(target)
    rtarget = revstr(target)

    found, remainder = onepass(rtarget, tosearch)
    log.debug('found %s' % len(found))
    log.debug(pformat([case[f] for f in found]))

    i = 0
    while len(remainder) > 2:
        i = i + 1
        log.debug('%s pass' % i)
        found, remainder = onepass(remainder, found)
        log.debug('found %s' % len(found))
        log.debug(pformat([case[f] for f in found]))
    log.debug('final results:')
    print '\n'.join([case[f] for f in found])
