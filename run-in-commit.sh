#! /bin//bash

SERIAL=$1
COMMIT=$2
TEST=$3

LOG=/tmp/run-test.log

(>&2 echo -n "$SERIAL ")
RESULT="$SERIAL $COMMIT $($COMMIT/install/bin/perl6 $TEST && echo OK || echo FAIL)" 2>/dev/null

flock -x -F $LOG -c "echo $RESULT >> $LOG"
