#!/bin/bash

# CHANGE THESE AFTER MIGRATION!!!
SOURCE_ROOT="/home/ubuntu/brandonhan.net"
WEB_ROOT="/var/www/brandonhan.net"
GIT_URL="https://github.com/RealBrandon/tech_docs.git"

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then
  echo "Please run the script again as ROOT!!!"

else
  rm -r $SOURCE_ROOT/content/post/ && 
  echo "$SOURCE_ROOT/content/post/ directory deleted" ||
  echo "$SOURCE_ROOT/content/post/ directory is already deleted." &&
  echo &&

  echo "Cloning from GitHub repository..." &&
  git clone $GIT_URL $SOURCE_ROOT/content/post/ &&
  echo &&
  rm -r $SOURCE_ROOT/content/post/Templates/ &&
  echo "$SOURCE_ROOT/content/post/Templates/ deleted" &&
  echo &&

  rm -r $SOURCE_ROOT/public/* &&
  echo "$SOURCE_ROOT/public/ directory cleared" &&
  echo &&
  cd $SOURCE_ROOT &&
  hugo &&
  echo &&

  rm -r $WEB_ROOT/* &&
  echo "$WEB_ROOT/ directory cleared" &&
  cp -r $SOURCE_ROOT/public/* $WEB_ROOT &&
  echo "Built files moved to web root" &&
  echo &&
  echo "The freshly built site is ready to go!" ||
  echo "The script ran into an error. Please check and then run it again."
fi
