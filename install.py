#!/usr/bin/env python
import os
import glob
import sys
from os.path import join,normpath,abspath
from pprint import pprint
import hashlib

debug = False
version = '0.3'
cfgname = '.cfg'
bkpname = 'backup.cfg'
gitrepo = 'git@github.com:durdn/cfg.git'
gitrepo_ro = 'git://github.com/durdn/cfg.git'
ignored = ['install.py',
           'install.pyc',
           '.git',
           '.gitignore',
           'README'
           ]

home = normpath(os.environ['HOME'])
backup_folder = normpath(join(home,bkpname)) 
cfg_folder = normpath(join(home,cfgname))

def call(command,fake = False):
    """
        call(command) --> (result, output)
        Runs the command in the local shell returning a tuple 
        containing :
            - the return result (None for 0, otherwise an int), and
            - the full, stripped standard output.

        You wouldn't normally use this, instead consider call(), test() and system()
    """
    print command
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

def list_all(path):
    "lists all files in a folder, including dotfiles"
    tmp = sum([glob.glob(normpath(join(a[0],'*')))  for a in os.walk(path)],[])
    return tmp + sum([glob.glob(normpath(join(a[0],'.*')))  for a in os.walk(path)],[])

def assets(rootpath,flist,test):
    return filter(lambda x: test(x), [normpath(join(rootpath,f)) for f in flist])

def local_assets(flist,test):
    return assets(home,flist,test)

def cfg_assets(flist,test):
    return filter(lambda x: test(x) and os.path.split(x)[1] not in ignored,
                  assets(cfg_folder,flist,test))

def backup_affected_assets(cfg_folder, backup_folder):
    "Backup files that would be overwritten by config tracking into backup folder"
    files = local_assets(os.listdir(cfg_folder),lambda x: True)
    for f in files:
        if os.path.exists(f):
            name = os.path.split(f)[1]
            hash = hashlib.sha1(f).hexdigest()
            call('mv %s %s' % (f,join(backup_folder,name)),fake=debug)

def install_tracked_assets(cfg_folder, destination_folder):
    "Install tracked configuration files into destination folder"
    files = cfg_assets(os.listdir(cfg_folder),os.path.isfile)
    for f in files:
        name = os.path.split(f)[1]
        dest = join(destination_folder,name)
        if os.path.exists(dest):
            hashsrc = hashlib.sha1(file(f).read()).hexdigest()
            hashdest = hashlib.sha1(file(dest).read()).hexdigest()
            if hashsrc != hashdest:
                call('mv %s %s' % (join(destination_folder,name),join(backup_folder,name)),fake=debug)
                call('ln -s %s %s' % (f,join(destination_folder,name)),fake=debug)
            else:
                call('F [unchanged] %s' % (join(destination_folder,name)),fake=True)
        else:
            call('ln -s %s %s' % (f,join(destination_folder,name)),fake=debug)

    dirs = cfg_assets(os.listdir(cfg_folder),os.path.isdir)
    for d in dirs:
        name = os.path.split(d)[1]
        destdir = join(destination_folder,name)
        if (os.path.exists(destdir)):
            dest_linksto = os.readlink(destdir)
            if  dest_linksto == d:
                call('D [unchanged] %s linked to %s' % (destdir, d), fake=True)
            else:
                call('mv %s %s' % (d,join(backup_folder,name)),fake=debug)
                call('ln -s %s %s' % (d,destdir),fake=debug)
        else:
            call('ln -s %s %s' % (d,destdir),fake=debug)



if __name__ == '__main__':
    print '|* cfg version', version
    print '|* home is', home
    print '|* backup folder is',backup_folder
    print '|* cfg folder is',cfg_folder

    #create backup folder for existing configs that will be overwritten
    if not os.path.exists(backup_folder):
        os.mkdir(backup_folder)

    #clone config folder if not present, update if present
    if not os.path.exists(cfg_folder):
        #clone cfg repo
        call("git clone %s %s" % (gitrepo,cfg_folder))
        if not os.path.exists(cfg_folder):
            print '!!! ssh key not installed on github for this box, cloning read only repo'
            call("git clone %s %s" % (gitrepo_ro,cfg_folder))
            print '|* changing remote origin to read/write repo: %s' % gitrepo
            call("cd %s && git config remote.origin.url %s" % (cfg_folder, gitrepo))
            if os.path.exists(join(home,'.ssh/id_rsa.pub')):
                print "|* please copy your public key below to github or you won't be able to commit"
                print
                print file(join(home,'.ssh/id_rsa.pub')).read()
            else:
                print '|* please generate your public/private key pair with the command:'
                print
                print 'ssh-keygen'
                print
                print '|* and copy the public key to github'
    else:
        if os.path.exists(join(cfg_folder,'.git')):
            print '|-> cfg already cloned to',cfg_folder
            print '|-> pulling origin master'
            if debug:
                call("cd %s" % (cfg_folder))
            else:
                call("cd %s && git pull origin master" % (cfg_folder))
        else:
            print '|-> git tracking projects not found in %s, ending program in shame' % cfg_folder

    stats = cfg_assets(os.listdir(cfg_folder),lambda x: True)
    print '|* tracking %d assets in %s' % (len(stats),cfgname)

    #print '|* backing up affected files...'
    #backup_affected_assets(cfg_folder,backup_folder)

    print '|* installing tracked config files...'
    install_tracked_assets(cfg_folder,home)
