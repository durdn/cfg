#!/bin/bash

debug=false;
version="0.2";
home=$HOME;
cfgname=".cfg";
bkpname="backup.cfg";
gitrepo="git@github.com:durdn/cfg.git";
gitrepo_ro="git://github.com/durdn/cfg.git";
ignored="install.py|install.pyc|install.sh|.git$|.gitmodule|.gitignore|README|bin";

#----debug setup----
#home=$1
#gitrepo=$2;
#------------------

cfg_folder=$home/$cfgname;
backup_folder=$home/$bkpname;

function md5prog {
  if [ $(uname) == "Darwin" ]; then
    md5 -q $1
  fi
  if [ $(uname) == "Linux" ]; then
    md5sum $1 | awk {'print $1'}
  fi
}

function update_submodules {
  return;
  if [ $debug == true ];
    then
      cd $cfg_folder
      echo "|-> initializing submodules [fake]"
      echo "|-> updating submodules [fake]"
    else
      echo "|-> initializing submodules"
      cd $cfg_folder && git submodule -q init
      echo "|-> updating submodules"
      cd $cfg_folder && git submodule update
  fi
}

function link_assets {
  for asset in $assets ;
  do
    if [ ! -e $home/$asset ];
      then
        #asset does not exist, can just copy it
        echo "N [new] $home/$asset";
        if [ $debug == false ];
          then ln -s $cfg_folder/$asset $home/$asset;
          else echo ln -s $cfg_folder/$asset $home/$asset;
        fi
      else
        #asset is there already
        if [ -d $home/$asset ];
          then
            if [ -h $home/$asset ];
              then echo "Id[ignore dir] $home/$asset";
              else
                echo "Cd[conflict dir] $home/$asset";
                mv $home/$asset $backup_folder/$asset;
                ln -s $cfg_folder/$asset $home/$asset;
            fi
          else
            ha=$(md5prog $home/$asset);
            ca=$(md5prog $cfg_folder/$asset);
            if [ $ha == $ca ];
              #asset is exactly the same
              then
                if [ -h $home/$asset ];
                  #asset is exactly the same and as link, all good
                  then echo "I [ignore] $home/$asset";
                  else
                    #asset must be relinked
                    echo "L [re-link] $home/$asset";
                    if [ $debug == false ];
                      then
                        mv $home/$asset $backup_folder/$asset;
                        ln -s $cfg_folder/$asset $home/$asset;
                      else
                        echo mv $home/$asset $backup_folder/$asset;
                        echo ln -s $cfg_folder/$asset $home/$asset;
                    fi
                fi
              else
                #asset exist but is different, must back it up
                echo "C [conflict] $home/$asset";
                if [ $debug == false ];
                  then
                    mv $home/$asset $backup_folder/$asset;
                    ln -s $cfg_folder/$asset $home/$asset;
                  else
                    echo mv $home/$asset $backup_folder/$asset;
                    echo ln -s $cfg_folder/$asset $home/$asset;
                fi
            fi
        fi
    fi
  done
}

echo "|* cfg version" $version
echo "|* debug is" $debug
echo "|* home is" $home
echo "|* backup folder is" $backup_folder
echo "|* cfg folder is" $cfg_folder

command -v git >/dev/null 2>&1 || { echo >&2 "git is not installed. Please install git before running the install script."; exit 1; }

if [ ! -e $backup_folder ];
  then mkdir -p $backup_folder;
fi

#clone config folder if not present, update if present
if [ ! -e $cfg_folder ];
  then 
    echo "|-> git clone from repo $gitrepo"
    git clone --recursive $gitrepo $cfg_folder;
    if [ ! -e $cfg_folder ];
      then
        echo "!!! ssh key not installed on github for this box, cloning read only repo"
        git clone --recursive $gitrepo_ro $cfg_folder
        echo "|* changing remote origin to read/write repo: $gitrepo"
        cd $cfg_folder && git config remote.origin.url $gitrepo
        if [ -e $home/id_rsa.pub  ];
          then
            echo "|* please copy your public key below to github or you won't be able to commit";
            echo
            cat $home/.ssh/id_rsa.pub
          else
            echo "|* please generate your public/private key pair with the command:"
            echo
            echo "ssh-keygen"
            echo
            echo "|* and copy the public key to github"
        fi
      else
        update_submodules
    fi
  else
    echo "|-> cfg already cloned to $cfg_folder"
    echo "|-> pulling origin master"
    cd $cfg_folder && git pull origin master
    update_submodules
fi

assets=$(ls -A1 $cfg_folder | egrep -v $ignored | xargs);
echo "|* tracking assets: [ $assets ] "
echo "|* linking assets in $home"
link_assets
