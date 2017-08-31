#!/bin/bash
AUTHOR=$(git config user.name)
DATE=$(date +%F)
git log --no-merges --format="%cd" --date=short --no-merges --author="$AUTHOR" --all | sort -u -r | while read DATE ; do
  if [ $NEXT != "" ]
  then
    echo
    echo [$NEXT]
  fi
  GIT_PAGER=cat git log --no-merges --format=" %s" --since=$DATE --until=$NEXT --author="$AUTHOR" --all
  NEXT=$DATE
done