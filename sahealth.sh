#!/bin/sh

WWWURI="https://sahealth.com/physicians/"
LOCALCOPY="physicians.html"
TMPFILE="tmpfile"
WEBFILE="changed.html"

MAILADDRESS="$(whoami)"
SUBJECT_NEWFILE="$LOCALCOPY is new"
BODY_NEWFILE="first version of $LOCALCOPY loaded"
SUBJECT_CHANGEDFILE="$LOCALCOPY updated"
SUBJECT_NOTCHANGED="$LOCALCOPY not updated"
BODY_CHANGEDFILE="new version of $LOCALCOPY"

# test for old file
if [ -e "$LOCALCOPY" ]
then
    mv "$LOCALCOPY" "$LOCALCOPY.bak"
    wget "$WWWURI" -O"$LOCALCOPY" -o/dev/null
    diff "$LOCALCOPY" "$LOCALCOPY.bak" > $TMPFILE

# test for update
    if [ -s "$TMPFILE" ]
    then
        echo "$SUBJECT_CHANGEDFILE"
        ( echo "$BODY_CHANGEDFILE" ; cat "$TMPFILE" ) | tee "$WEBFILE" | mail -s "$SUBJECT_CHANGEDFILE" "$MAILADDRESS"
    else
        echo "$SUBJECT_NOTCHANGED"
    fi
else
    wget "$WWWURI" -O"$LOCALCOPY" -o/dev/null
    echo "$BODY_NEWFILE"
    echo "$BODY_NEWFILE" | tee "$WEBFILE" | mail -s "$SUBJECT_NEWFILE" "$MAILADDRESS"
fi
[ -e "$TMPFILE" ] && rm "$TMPFILE"
