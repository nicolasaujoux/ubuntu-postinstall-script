#!/bin/bash

#######################################################################
#####        Installation and configuration script for Ubuntu     #####
#######################################################################
#  Auteur : Nicolas Aujoux
#######################################################################

# Root test
if [ $USER = "root" -o $UID = 0 ]
then
  echo "This script should NOT be launched with root access."
  echo "Your password will be asked during installation"
  echo "Cancel"
  exit 1
fi


echo "Be sure to read and understand the script before launching it."
echo -n "Are you sure you want to continue ? (y/n): "
read rep
if [ $rep != "y" ] && [ $rep != "yes" ]
then
  exit 1
fi

#################################################################
##### Variables Init
##################################################################
DEV_PACKAGES="0" 
MULTIMEDIA_PACKAGES="0"

##################################################################
##### Packages available in official ubuntu repos #####
##################################################################
# Internet
PAQUETS="gm-notify chromium-browser skype"

# Dev
echo "Do you want to install DEVELOPPMENT packages ? (y/n) :" 
read rep 
if [ $rep = "y" ] || [ $rep = "yes" ]
then
    PAQUETS=$PAQUETS" vim-gnome gcc subversion git gitg git-flow mercurial zsh ctags tmux rubygems"
    DEV_PACKAGES="1"
fi

# Multimedia
echo "Do you want to install MULTIMEDIA packages ? (y/n) :"
read rep
if [ $rep = "y" ] || [ $rep = "yes" ]
then
    PAQUETS=$PAQUETS" vlc gimp"
    MULTIMEDIA_PACKAGES="1"
fi
# Others
PAQUETS=$PAQUETS" gparted "

##################################################################
##### Non official ubuntu repos #####
##################################################################
if [ MULTIMEDIA_PACKAGES = "1" ]
then
    #### Spotify ####
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
    PAQUETS=$PAQUETS" spotify-client"
fi

##################################################################
##### Installation #####
##################################################################
#### List update ####
echo "sudo apt-get update"
sudo apt-get update

#### System update ####
echo "sudo apt-get -y upgrade"
sudo apt-get -y upgrade

#### Packages installation ####
echo "apt-get -y install "$PAQUETS
sudo apt-get -y install $PAQUETS

##################################################################
##### Gem packages and Homesick #####
##################################################################
if [ $DEV_PACKAGES = "1" ]
then
    ####################################################################
    ##### Oh my zsh #####
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    chsh -s /bin/zsh

    ####################################################################
    ##### Gem packages #####
    #redcarpet is for markdown files
    PAQUETS_GEM="tilt github-markup redcarpet homesick"

    echo "gem install "$PAQUETS_GEM
    sudo gem install $PAQUETS_GEM

    ####################################################################
    ##### dotfiles with homesick from git #####
    echo "dotfiles with homesick"
    homesick clone nicolasaujoux/dotfiles
    homesick symlink nicolasaujoux/dotfiles
    cd ~/.homesick/repos/nicolasaujoux/dotfiles
    git submodule update --init
    vim +BundleInstall +qall
fi

#####################################################################
# Allow every applications to display into the notification bar for 
# unity.
##################################################################
gsettings set com.canonical.Unity.Panel systray-whitelist "['all']"

