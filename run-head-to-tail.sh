#! /bin/bash

PASTCOMMITS=$1
SCRIPT=$2
CORES=$(grep -c ^processor /proc/cpuinfo)
COMMITS=$(git -C HEAD log --oneline --no-abbrev-commit | cut -d ' ' -f 1 | head -n $PASTCOMMITS)

test -f /tmp/run-test.log && rm /tmp/run-test.log
COUNTER=1
LINES=""
for LINE in $COMMITS
do
	if test -f "$LINE/install/bin/perl6"; then
		LINES="$LINES $COUNTER $LINE $SCRIPT"
	else 
	 	echo "$COUNTER $LINE SKIP" >> /tmp/run-test.log
	fi
	COUNTER=$(( COUNTER + 1 ))
done
 
echo $LINES | xargs -P $CORES -n 3 sh run-in-commit.sh
sort -n -k 1 /tmp/run-test.log
