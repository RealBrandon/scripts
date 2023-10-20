#!/bin/bash

# CHANGE THESE AFTER MIGRATION!!!
CONTENT_ROOT="/home/ubuntu/asymptote.cc"
WEB_ROOT="/var/www/asymptote.cc"
GIT_URL="https://github.com/SalmonCloud/asymptote_homepage.git"

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then
  echo "Please run the script again as ROOT!!!"

else
  echo "Syncing with GitHub repository..." &&
  cd $CONTENT_ROOT/github_repo/ &&
  git pull $GIT_URL &&
  echo &&

  cp $CONTENT_ROOT/github_repo/about_page.md $CONTENT_ROOT/content/about.md &&
  cp $CONTENT_ROOT/github_repo/info_page.md $CONTENT_ROOT/content/info.md &&
  echo "Markdown files copied to $CONTENT_ROOT/content/" &&

  rm -r $CONTENT_ROOT/public/* &&
  echo "$CONTENT_ROOT/public/ directory cleared" &&
  echo &&

  cd $CONTENT_ROOT &&
  hugo &&
  echo &&

  rm -r $WEB_ROOT/* &&
  echo "$WEB_ROOT/ directory cleared" &&
  cp -r $CONTENT_ROOT/public/* $WEB_ROOT &&
  echo "Built Hugo files copied to $WEB_ROOT/" &&
  echo &&

  cp $CONTENT_ROOT/github_repo/AS53616.csv $WEB_ROOT/geofeed.csv &&
  echo "CSV file copied to $WEB_ROOT/geofeed.csv" &&
  cp $CONTENT_ROOT/github_repo/AS53616.csv $WEB_ROOT/geofeed.txt &&
  echo "CSV file copied to $WEB_ROOT/geofeed.txt" &&
  echo &&

  #cp $CONTENT_ROOT/github_repo/AS53616.csv $CONTENT_ROOT &&
  #python3 $CONTENT_ROOT/geofeed_page_maker.py &&
  #mkdir $WEB_ROOT/geofeed/ &&
  #cp $CONTENT_ROOT/geofeed.html $WEB_ROOT/geofeed/index.html &&
  #echo "Geofeed page built and copied to $WEB_ROOT/geofeed/index.html" &&
  #echo &&

  echo "The freshly built site is ready to go!" ||
  echo "The script ran into an error. Please check and then run the script again."
fi
