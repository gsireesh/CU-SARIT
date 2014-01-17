#!/bin/bash

# Get rid of hyphenated line breaks
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\([^>]\)-\n/\1/g' $1
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\([^>]\)\n/\1 /g' $1

# Then add in spacing back to lg elements
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/<lg>\n<l>/<lg>\n  <l>/g' $1
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/<\/l>\n<l>/<\/l>\n  <l>/g' $1

# pb elements
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/\(.\)<pb n="\(.*\)"\/>\n/\1<pb n="\2"\/>/g' $1
sed -i -e ':a' -e 'N' -e '$!ba' -e 's/ <pb n="\(.*\)"\/>\n/ <pb n="\1"\/>/g' $1
