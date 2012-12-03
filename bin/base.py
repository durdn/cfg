#!/usr/bin/env python
import os
import sys
import argparse
import logging as log
from pprint import pformat, pprint

def get_options():
    maxres = 20
    collect_command = 'git ls-files'
    find_collect_command = 'find . -type f'

    parser = argparse.ArgumentParser(description='command-t like shell command')
    parser.add_argument('target', metavar='target', help='the target pattern to search')
    parser.add_argument('-c', '--command', help='command to collect a list of files (default: git ls-files)')
    parser.add_argument('-f', '--find', action='store_true', help='use find collect command (find . -type f)')
    parser.add_argument('-m', '--max', type=int, help='stop at max results')
    parser.add_argument('-v', '--verbose', action='store_true', help='verbose: print out debug information')
    options = parser.parse_args()

    if options.verbose:
        log.basicConfig(level=log.DEBUG)
    else:
        log.basicConfig(level=log.INFO)

    if options.find:
        collect_command = find_collect_command
    elif options.command:
        collect_command = options.command 

    if options.max:
        maxres = options.max

    return options.target, collect_command, maxres

if __name__ == '__main__':
    get_options()
